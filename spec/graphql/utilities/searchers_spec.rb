require_relative '../../../app/graphql/utilities/searchers.rb'

RSpec.describe Searchers do
  subject(:complete_searcher) { Searchers::Complete.new }

  describe 'querying all events for a specific :userId' do
    let(:users_id) { 123 }
    let!(:no_user_events) { create_list(:event, 3) }

    context 'when there are no events by that user' do
      it 'returns no events' do
        expect(complete_searcher.search(user_id: users_id)).to be_empty
      end
    end

    context 'when there are events by that user' do
      let!(:events) { create_list(:event, 3, user_id: users_id) }
      it 'returns the expected events only' do
        results = complete_searcher.search(user_id: users_id)
        expect(results).to match_array(events)
      end
    end
  end

  subject(:bucket_searcher) { Searchers::Bucket.new }

  describe 'bucketing events for a specific :userId or :projectId with a specific event_type' do
    let(:users_id) { 123 }
    let(:event_types) { 'classification' }
    let(:time_bucket) { '1 day' }
    let(:arguments) do
      {
        time_bucket:    time_bucket,
        user_id:        users_id,
        event_type:     event_types
      }
    end
    let(:start_time) { Time.zone.parse('2018-11-06 10:30:10') }
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
            "bucket"  => start_time.midnight,
            "count"   => 1
          },
          {
            "bucket"  => mid_time.midnight,
            "count"   => 2
          },
          {
            "bucket"  => end_time.midnight,
            "count"   => 3
          }
        ]
        results = bucket_searcher.search(**arguments).map(&:attributes)
        expect(results).to match_array(expected)
      end
    end
  end
end