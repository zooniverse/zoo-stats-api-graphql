RSpec.shared_examples 'a statsCount query' do |input|
  let(:query_string) { input[:query_string] }
  let(:context) { {admin: true} }
  let(:variables) { input[:variables] }
  let(:result) {
    res = ZooStatsSchema.execute(
      query_string,
      context: context,
      variables: variables
    )
    if res["errors"]
      pp res
    end
    res
  }
  let(:base_attributes) do
    {
      event_type:   'classification',
      event_source: 'panoptes'
    }
  end
  let(:attributes_not_matching) do
    base_attributes.merge({
      user_id:     111,
      project_id:  222,
      workflow_id: 333,
    })
  end
  let!(:events_type_0) { create_list(:event, 3, **attributes_not_matching) }

  context 'when there are no matching events' do
    it 'returns no events' do
      result_data = result["data"]
      expect(result_data).not_to be_nil
      expect(result_data['statsCount']).to be_empty
    end
  end

  context 'when there are matching events' do
    let(:start_time) { Time.zone.parse('2018-11-06 05:45:09') }
    let(:attributes_matching_time_1) do
      base_attributes.merge({
        user_id:     123,
        project_id:  456,
        workflow_id: 789,
        event_time:  start_time,
      })
    end
    let(:mid_time) { start_time + 2.day }
    let(:attributes_matching_time_2) do
      base_attributes.merge({
        user_id:     123,
        project_id:  456,
        workflow_id: 789,
        event_time:  mid_time,
      })
    end
    let!(:events_type_1) { create_list(:event, 1, **attributes_matching_time_1) }
    let!(:events_type_2) { create_list(:event, 2, **attributes_matching_time_2) }
    let(:output) do
      output = [
        {"period"=>"2018-11-06T00:00:00Z", "count"=>1},
        {"period"=>"2018-11-08T00:00:00Z", "count"=>2}
      ]
    end
    it 'returns correct events' do
      expect(result["data"]['statsCount']).to eq(output)
    end
  end
end

RSpec.describe ZooStatsSchema do
  describe 'statsCount' do
    context 'with a queried projectId' do
      query_string = "query ($projectId: ID!, $eventType: String!, $interval: String!){
        statsCount(projectId: $projectId, eventType: $eventType, interval: $interval){
          period,
          count
        }
      }"
      variables = {
        "projectId": 456,
        "eventType": 'classification',
        "interval": '1 day'
      }

      it_behaves_like 'a statsCount query', { query_string: query_string, variables: variables }
    end

    context 'with a queried workflowId' do
      query_string = "query ($workflowId: ID!, $eventType: String!, $interval: String!){
        statsCount(workflowId: $workflowId, eventType: $eventType, interval: $interval){
          period,
          count
        }
      }"
      variables = {
        "workflowId": 789,
        "eventType": 'classification',
        "interval": '1 day'
      }
      
      it_behaves_like 'a statsCount query', { query_string: query_string, variables: variables }
    end

    context 'with a queried userId' do
      query_string = "query ($userId: ID!, $eventType: String!, $interval: String!){
        statsCount(userId: $userId, eventType: $eventType, interval: $interval){
          period,
          count
        }
      }"
      variables = {
        "userId": 123,
        "eventType": 'classification',
        "interval": '1 day'
      }
      
      it_behaves_like 'a statsCount query', { query_string: query_string, variables: variables }
    end

    let(:result) {
      ZooStatsSchema.execute(
        query_string,
        context: context,
        variables: variables
      )
    }
    let(:context) { {} }

    context 'authorization with no queries' do
      let(:variables) do
        {
          "eventType": 'classification',
          "interval": '1 day'
        }
      end
      let(:query_string) do
        "query ($eventType: String!, $interval: String!){
          statsCount(eventType: $eventType, interval: $interval){
            period,
            count
          }
        }"
      end
      let!(:events) { create_list(:event, 3, event_type: 'classification') }

      context 'when the current user is not an :admin' do
        it 'returns no events' do
          output = result
          expect(output["data"]).to be_nil
          expect(output["errors"].first["message"]).to eq("Permission denied")
        end
      end

      context 'when the current user is an :admin' do
        let(:context) { {admin: true} }
        it 'returns correct events' do
          expect(result["data"]["statsCount"]).not_to be_empty
        end
      end
    end

    context 'authorization with a queried userId' do
      let(:variables) do
        {
          "userId": current_user,
          "eventType": 'classification',
          "interval": '1 day'
        }
      end
      let(:query_string) do
        "query ($userId: ID!, $eventType: String!, $interval: String!){
          statsCount(userId: $userId, eventType: $eventType, interval: $interval){
            period,
            count
          }
        }"
      end
      let(:current_user) { 123 }
      let(:wrong_user) { 456 }
      let(:attributes) do
        {
          user_id: current_user,
          event_time: Time.zone.parse('2018-11-06 05:45:09'),
          event_type: 'classification'
        }
      end
      let!(:events) { create_list(:event, 3, **attributes) }

      context 'when there is no :current_user' do
        it 'returns no events' do
          output = result
          expect(output["data"]).to be_nil
          expect(output["errors"].first["message"]).to eq("Permission denied")
        end
      end
    
      context 'when the queried :user_id is not :current_user' do
        let(:context) { {current_user: wrong_user} }
        it 'returns no events' do
          output = result
          expect(output["data"]).to be_nil
          expect(output["errors"].first["message"]).to eq("Permission denied")
        end
      end
    
      context 'when the current user is an :admin' do
        let(:context) { {admin: true} }
        it 'returns correct events' do
          expect(result["data"]["statsCount"]).not_to be_empty
        end
      end
      
      context 'when the queried :user_id is :current_user' do
        let(:context) { {current_user: current_user} }
        it 'returns correct events' do
          expect(result["data"]["statsCount"]).not_to be_empty
        end
      end
    end
  end
end
