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
    allow(Transformers).to receive(:for) { |event| (Transformers::TransformerDouble.new(event)) }
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
      let(:event_attributes) { attributes_for(:complete_event) }
      let(:event_payload) { JSON.dump([event_attributes]) }

      it 'adds the correct Event into the database' do
        expect { result }.to change { Event.count }.by 1

        stored_attributes = Event.last.attributes.to_options
        event_attributes.each do |key, value|
          expect(value).to eq(stored_attributes[key])
        end
        expect(stored_attributes[:session_time]).to eq(1.0)
      end
    end

    context 'when there is an erroring event' do
      let(:event_1) { attributes_for(:complete_event) }
      let(:event_2) { attributes_for(:complete_event) }
      let(:event_3) { attributes_for(:complete_event, event_source: nil) }
      let(:event_payload) { JSON.dump([event_1, event_2, event_3]) }

      it 'reverts the batch and returns the error' do
        expect { result }.not_to change { Event.count }
        expect(result["errors"][0]["message"]).to eq("Validation failed: Event source can't be blank")
      end
    end

    context 'when there is a repeated event' do
      let(:event_attributes) { attributes_for(:complete_event) }
      let(:event_payload) { JSON.dump([event_attributes, event_attributes]) }

      it 'add only one row to the database without errors' do
        expect { result }.to change { Event.count }.by 1
        errors = result["data"]["createEvent"]["errors"][0]
        expect(errors).to be_nil
      end
    end

    context 'authentication and authorization' do
      let(:event_attributes) { attributes_for(:complete_event) }
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
      payload["session_time"] = 1.0
      payload
    end
  end
end