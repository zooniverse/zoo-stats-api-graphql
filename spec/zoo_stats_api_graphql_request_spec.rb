Rspec.describe 'ZooStatsApiGraphql', type: :request do
  describe '/' do
    it 'should return a health check response' do
      get '/'
      expected_response = {"status"=>"ok", "version"=>VERSION}
      expect(response.body).to eq(expected_response.to_json)
    end
  end
end