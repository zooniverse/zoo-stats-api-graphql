Rspec.describe ZooStatsSchema do
  let(:context) { {} }
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
    allow(Transformers).to receive(:for).and_return(Transformers::TransformerDouble)
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
  end
end

module Transformers
  class TransformerDouble
    attr_accessor :payload
    def initialize(payload)
      @payload = payload
    end

    def transform
      payload
    end
  end
end