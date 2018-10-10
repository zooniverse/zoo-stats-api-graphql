RSpec.describe Types::QueryType do
  subject { Types::QueryType }
  let(:context) { {} }
  let(:variables) { {} }
  # Call `result` to execute the query
  let(:result) {
    res = ZooStatsSchema.execute(
      query_string,
      context: context,
      variables: variables
    )
    # Print any errors
    if res["errors"]
      pp res
    end
    res
  }

  describe 'querying all events for a specific :projectId' do
    it 'has a :project_id_query field that returns Event types' do
      field_name = "projectIdQuery"
      field_type = "[Event!]!"
      expect(subject.fields[field_name].type.to_type_signature).to eq(field_type)
    end

    let(:projects_id) { 456 }
    let(:query_string) do
      "{
        projectIdQuery(projectId: #{projects_id}){
          eventId
          eventTime
          projectId
        }
      }"
    end
      
    let!(:non_project_events) { create_list(:event, 3) }
    context 'when there are no events from that project' do
      it 'returns no events' do
        expect(result["data"]).not_to be_nil
        expect(result["data"]["projectIdQuery"]).to be_empty
      end
    end
    
    context 'when there are events from that project' do
      let!(:events) { create_list(:event, 3, project_id: projects_id) }
      it 'returns the expected events only' do
        expect(result["data"]).not_to be_nil
        data = result["data"]["projectIdQuery"]
        expect(data.uniq.count).to eq(events.count)

        eventIds = []
        eventTimes = []
        projectIds = []
        data.each do |item|
          eventIds.append(item["eventId"])
          eventTimes.append(item["eventTime"])
          projectIds.append(item["projectId"])
        end

        events.each do |event|
          expect(eventIds).to include(event.event_id.to_s)
          expect(eventTimes).to include(event.event_time.iso8601)
          expect(projectIds).to include(event.project_id.to_s)
        end
      end
    end
  end
end