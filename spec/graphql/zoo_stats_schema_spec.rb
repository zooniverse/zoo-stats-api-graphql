RSpec.describe Types::QueryType do
  subject(:query_type) { Types::QueryType }
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

  describe 'querying all events for a specific :userId' do
    let(:users_id) { 123 }
    let(:query_string) do
      "{
        userIdQuery(userId: #{users_id}){
          eventId
          eventTime
          userId
        }
      }"
    end
      
    let!(:non_user_events) { create_list(:event, 3) }
    context 'when there are no events by that user' do
      it 'returns no events' do
        expect(result["data"]).not_to be_nil
        expect(result["data"]["userIdQuery"]).to be_empty
      end
    end
    
    context 'when there are events by that user' do
      let!(:events) { create_list(:event, 3, user_id: users_id) }
      it 'returns the expected events only' do
        expect(result["data"]).not_to be_nil
        data = result["data"]["userIdQuery"]
        expect(data.uniq.count).to eq(events.count)

        eventIds = []
        eventTimes = []
        userIds = []
        data.each do |item|
          eventIds.append(item["eventId"])
          eventTimes.append(item["eventTime"])
          userIds.append(item["userId"])
        end

        events.each do |event|
          expect(eventIds).to include(event.event_id.to_s)
          expect(eventTimes).to include(event.event_time.iso8601)
          expect(userIds).to include(event.user_id.to_s)
        end
      end
    end
  end

  describe 'querying all events for a specific :projectId' do
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