Rspec.describe ZooStatsSchema do
  let(:context) do
    {
      basic_user:     "user",
      basic_password: "secret"
    }
  end
  let(:variables) { {"event_payload": event_payload} }
  let(:mutation_string) do
    "mutation ($event_payload: String!){
      createEvent(eventPayload: $event_payload){
        errors
      }
    }"
  end
  let(:result) do
    ZooStatsSchema.execute(
      mutation_string,
      context: context,
      variables: variables
    )
  end

  before do
    allow(Rails.application.credentials).to receive(:mutation_username_staging).and_return("user")
    allow(Rails.application.credentials).to receive(:mutation_password_staging).and_return("secret")
    allow(Transformers).to receive(:for) do |event|
      Transformers::TransformerDouble.new(event)
    end
  end

  describe 'createEvent' do
    context 'when there is an empty payload' do
      let(:event_payload) { "" }

      it 'throws an Argument error' do
        errors = result["data"]["createEvent"]["errors"]
        message = eval(errors[0])["message"]
        expect(message).to start_with("Argument")
      end

      it 'does not add anything to the database' do
        expect { result }.not_to change { Event.count }
      end
    end

    context 'when there is a single event payload' do
      let(:event_attributes) do
        event_attrs = attributes_for(:event).with_indifferent_access
        transformer_double = Transformers::TransformerDouble.new(event_attrs)
        transformer_double.transform
      end
      let(:event_payload) { JSON.dump([event_attributes]) }

      it 'adds the correct Event into the database' do
        expect { result }.to change { Event.count }.by 1

        stored_attributes = Event.last.attributes
        event_attributes.each do |key, value|
          expect(value).to eq(stored_attributes[key])
        end
      end
    end

    context 'when there is an erroring event' do
      let(:event_1) { attributes_for(:event) }
      let(:event_2) { attributes_for(:event) }
      let(:event_3) { attributes_for(:event, event_source: nil) }
      let(:event_payload) { JSON.dump([event_1, event_2, event_3]) }

      it 'does not add any records to the db' do
        # rescue the operation here to allow the test to proceed
        expect { result rescue  nil }.not_to change { Event.count } # rubocop:disable Style/RescueModifier
      end

      it 'raises an error and stops processing' do
        expect { result }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'when there is an upsert in the payload' do
      let(:event) { build(:event) }
      let(:new_session_time) { rand(3.5..9.7).round(3) }
      let(:upsert_event_attributes) do
        attrs = event.attributes
        attrs[:session_time] = new_session_time
        attrs
      end
      let(:event_payload) { JSON.dump([upsert_event_attributes]) }

      it 'should upsert the data' do
        event.save
        expect { result }.not_to change { Event.count }
        expect(event.reload.session_time).to eq(new_session_time)
        errors = result["data"]["createEvent"]["errors"]
        expect(errors).to be_empty
      end
    end

    context 'when there is a repeated event in the payload' do
      let(:event_attributes) { attributes_for(:event) }
      let(:event_attributes) { attributes_for(:event) }
      let(:event_payload) { JSON.dump([event_attributes, event_attributes]) }

      it 'adds non-duplicate records to the db' do
        expect { result }.to change { Event.count }.from(0).to(1)
      end

      it 'adds the correct Event into the database' do
        result
        stored_attributes = Event.last.attributes
        expect(stored_attributes).to include(event_attributes.stringify_keys)
      end
    end

    context 'authentication and authorization' do
      let(:event_attributes) { attributes_for(:event) }
      let(:event_payload) { JSON.dump([event_attributes]) }

      context 'when there is no basic authentication' do
        let(:context) do
          {
            basic_user:     nil,
            basic_password: nil
          }
        end

        it 'returns unauthorized' do
          expect { result }.not_to change { Event.count }
          expect(result["errors"].first["message"]).to eq("Unauthorized")
        end
      end

      context 'when the user is wrong' do
        let(:context) do
          {
            basic_user: "wrong_user",
            basic_password: "secret"
          }
        end

        it 'returns permission denied' do
          expect { result }.not_to change { Event.count }
          expect(result["errors"].first["message"]).to eq("Permission denied")
        end
      end

      context 'when the password is incorrect' do
        let(:context) do
          {
            basic_user: "user",
            basic_password: "not_so_secret"
          }
        end

        it 'returns permission denied' do
          expect { result }.not_to change { Event.count }
          expect(result["errors"].first["message"]).to eq("Permission denied")
        end
      end
    end
  end
end

module Transformers
  class TransformerDouble
    attr_accessor :payload
    def initialize(payload)
      @payload = payload
    end

    def transform
      payload["session_time"] ||= 1.0
      payload["country_name"] ||= "United Kingdom"
      payload["country_code"] ||= "GB"
      payload["city_name"]    ||= "Oxford"
      payload["latitude"]     ||= 100.1
      payload["longitude"]    ||= -100.1
      payload
    end
  end
end
