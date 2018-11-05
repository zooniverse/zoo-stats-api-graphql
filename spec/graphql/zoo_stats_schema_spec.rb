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
        event_id:   1
      }
    end
    let(:attributes_type_0) do
      base_attributes.merge({
        user_id:    111,
        project_id: 222
      })
    end
    let(:attributes_type_1) do
      base_attributes.merge({
        user_id:    123,
        project_id: 456,
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
      let!(:events_type_1) { create_list(:event, 3, **attributes_type_1) }
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
end