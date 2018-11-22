Rspec.describe ZooStatsSchema do
  let(:context) { {} }
  let(:variables) { {} }
  let(:mutation_string) do
    "mutation {
      createEvent(eventPayload: #{event_payload}){
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
    transformer_stub = double("transformer_stub", :transform => prepared_payload)
    event_payload_hash = eval(event_payload[0]) if not event_payload.nil?
    allow(Transformers::PanoptesClassification).to receive(:new).with(event_payload_hash).and_return(transformer_stub)
  end

  describe 'createEvent' do
    context 'when there is an empty payload' do
      let(:event_payload) { nil }
      let(:prepared_payload) { nil }
      it 'throws an Argument error' do
        expect(result["errors"][0]["message"]).to start_with("Argument")
      end

      it 'does not add anything to the database' do
        expect { result }.not_to change { Event.count }
      end
    end

    context 'when there is a single event payload' do
      let(:event_payload) { ["{\"test\" => \"hash\"}"] }
      let(:prepared_payload) do 
        {
          event_id:            123,
          event_type:          "classification",
          event_source:        "Panoptes",
          event_time:          DateTime.parse('2018-11-06 05:45:09'),
          project_id:          456,
          workflow_id:         789,
          user_id:             1011,
          data:                {"metadata" => 'test'},
          session_time:        5.0
        }
      end
      it 'Adds the correct Event into the database' do
        expect { result }.to change { Event.count }.by 1

        stored_attributes = Event.last.attributes.to_options
        prepared_payload.each do |key, value|
          expect(value).to eq(stored_attributes[key])
        end
      end
    end
  end
end