RSpec.shared_examples 'a graphQL query' do |query_name, query_string, output, current_user|
  let(:context) { {current_user: current_user} }
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
  let(:query_string) { query_string }
  let(:base_attributes) do
    {
      event_id:   1,
      event_type: 'classification'
    }
  end
  let(:attributes_type_0) do
    base_attributes.merge({
      user_id:    111,
      project_id: 222,
    })
  end
  let(:start_time) { Time.zone.parse('2018-11-06 05:45:09') }
  let(:attributes_type_1) do
    base_attributes.merge({
      user_id:    123,
      project_id: 456,
      event_time: start_time,
    })
  end
  let(:mid_time) { start_time + 2.day }
  let(:attributes_type_2) do
    base_attributes.merge({
      user_id:    123,
      project_id: 456,
      event_time: mid_time,
    })
  end
  let!(:events_type_0) { create_list(:event, 3, **attributes_type_0) }

  context 'when there are no matching events' do
    it 'returns no events' do
      result_data = result["data"]
      expect(result_data).not_to be_nil
      expect(result_data[query_name]).to be_empty
    end
  end

  context 'when there are matching events' do
    let!(:events_type_1) { create_list(:event, 1, **attributes_type_1) }
    let!(:events_type_2) { create_list(:event, 2, **attributes_type_2) }
    it 'returns correct events' do
      expect(result["data"][query_name]).to eq(output)
    end
  end
end

Rspec.shared_examples 'an authorizing user query' do |query_name, query_string, users_id, wrong_user|
  let(:current_user) { users_id }
  let(:wrong_user) { wrong_user }
  let(:query_string) { query_string }
  let(:context) { {} }
  let(:variables) { {} }
  # Call `result` to execute the query
  let(:result) {
    ZooStatsSchema.execute(
      query_string,
      context: context,
      variables: variables
    )
  }
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
  
  context 'when the queried :user_id is :current_user' do
    let(:context) { {current_user: current_user} }
    it 'returns correct events' do
      expect(result["data"][query_name]).not_to be_empty
    end
  end
end

Rspec.describe ZooStatsSchema do
  describe 'userIdQuery' do
    query_name = 'userIdQuery'
    users_id = 123
    wrong_user = 456
    query_string = "{
      userIdQuery(userId: #{users_id}){
        userId
      }
      }"
      output = [
        {"userId"=>"123"},
        {"userId"=>"123"},
        {"userId"=>"123"}
      ]
      it_behaves_like 'an authorizing user query', query_name, query_string, users_id, wrong_user
      it_behaves_like 'a graphQL query', query_name, query_string, output, users_id
  end
    
  describe 'projectIdQuery' do
    query_name = 'projectIdQuery'
    projects_id = 456
    query_string = "{
      projectIdQuery(projectId: #{projects_id}){
        projectId
      }
      }"
      output = [
        {"projectId"=>"456"},
        {"projectId"=>"456"},
        {"projectId"=>"456"}
      ]
      it_behaves_like 'a graphQL query', query_name, query_string, output, 0
  end
      
  describe 'userStatsCount' do
    query_name = 'userStatsCount'
    user_id = 123
    wrong_user = 456
    event_type = 'classification'
    time_bucket = '1 day'
    query_string = "{
      userStatsCount(userId: #{user_id}, eventType: \"#{event_type}\", interval: \"#{time_bucket}\"){
        period,
        count
      }
    }"
    output = [
      {"period"=>"2018-11-06T00:00:00Z", "count"=>1},
      {"period"=>"2018-11-08T00:00:00Z", "count"=>2}
    ]
    it_behaves_like 'an authorizing user query', query_name, query_string, user_id, wrong_user
    it_behaves_like 'a graphQL query', query_name, query_string, output, user_id
  end

  describe 'projectStatsCount' do
    query_name = 'projectStatsCount'
    project_id= 456
    event_type = 'classification'
    time_bucket = '1 day'
    query_string = "{
      projectStatsCount(projectId: #{project_id}, eventType: \"#{event_type}\", interval: \"#{time_bucket}\"){
        period,
        count
      }
    }"
    output = [
      {"period"=>"2018-11-06T00:00:00Z", "count"=>1},
      {"period"=>"2018-11-08T00:00:00Z", "count"=>2}
    ]
    it_behaves_like 'a graphQL query', query_name, query_string, output, 0
  end
end