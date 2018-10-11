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
    it 'has a :user_id_query field that returns Event types' do
      field_name = "userIdQuery"
      field_type = "[Event!]!"
      expect(query_type.fields[field_name].type.to_type_signature).to eq(field_type)
    end

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
end