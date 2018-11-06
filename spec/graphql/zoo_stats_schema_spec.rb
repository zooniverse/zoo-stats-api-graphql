RSpec.shared_examples 'a graphQL query' do |query_name, query_string, output|
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

Rspec.describe ZooStatsSchema do
  describe 'userIdQuery' do
    query_name = 'userIdQuery'
    users_id = 123
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
      it_behaves_like 'a graphQL query', query_name, query_string, output
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
      it_behaves_like 'a graphQL query', query_name, query_string, output
  end
      
  describe 'userBucketQuery' do
    query_name = 'userBucketQuery'
    user_id = 123
    event_type = 'classification'
    time_bucket = '1 day'
    query_string = "{
      userBucketQuery(userId: #{user_id}, eventType: \"#{event_type}\", timeBucket: \"#{time_bucket}\"){
        bucket,
        count
      }
    }"
    output = [
      {"bucket"=>"2018-11-06T00:00:00Z", "count"=>1},
      {"bucket"=>"2018-11-08T00:00:00Z", "count"=>2}
    ]
    it_behaves_like 'a graphQL query', query_name, query_string, output
  end

  describe 'projectBucketQuery' do
    query_name = 'projectBucketQuery'
    project_id= 456
    event_type = 'classification'
    time_bucket = '1 day'
    query_string = "{
      projectBucketQuery(projectId: #{project_id}, eventType: \"#{event_type}\", timeBucket: \"#{time_bucket}\"){
        bucket,
        count
      }
    }"
    output = [
      {"bucket"=>"2018-11-06T00:00:00Z", "count"=>1},
      {"bucket"=>"2018-11-08T00:00:00Z", "count"=>2}
    ]
    it_behaves_like 'a graphQL query', query_name, query_string, output
  end
end