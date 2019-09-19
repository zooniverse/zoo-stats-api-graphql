RSpec.describe Searchers do
  subject(:bucket_searcher) { Searchers::Bucket }

  describe 'bucketing events for a specific :userId or :projectId with a specific event_type' do
    let(:users_id) { 123 }
    let(:event_types) { 'classification' }
    let(:time_bucket) { '1 day' }
    let(:window) { '1 Week' }
    let(:arguments) do
      {
        interval:    time_bucket,
        user_id:     users_id,
        event_type:  event_types,
        window:      window
      }
    end
    let(:start_time) { Time.zone.now - 4.days }
    let!(:generic_classifications) { create_list(:event, 3, event_time: start_time, event_type: 'classification') }
    let!(:generic_comments) { create_list(:event, 3, event_time: start_time, event_type: 'comment') }

    context 'when there are no events by that user' do
      it 'returns no buckets' do
        results = bucket_searcher.search(**arguments)
        expect(results).to match_array([])
      end
    end

    context 'when there are events by that user' do
      let(:mid_time) { start_time + 2.day }
      let(:end_time) { mid_time + 2.day }
      before(:each) do
        create_list(:event, 1, user_id: users_id, event_time: start_time, event_type: event_types)
        create_list(:event, 2, user_id: users_id, event_time: mid_time, event_type: event_types)
        create_list(:event, 3, user_id: users_id, event_time: end_time, event_type: event_types)
      end
      it 'returns the expected buckets' do
        expected = [
          {
            "period"  => start_time.midnight,
            "count"   => 1
          },
          {
            "period"  => mid_time.midnight,
            "count"   => 2
          },
          {
            "period"  => end_time.midnight,
            "count"   => 3
          }
        ]
        results = bucket_searcher.search(**arguments).map(&:attributes)
        expect(results).to match_array(expected)
      end
    end
  end
end