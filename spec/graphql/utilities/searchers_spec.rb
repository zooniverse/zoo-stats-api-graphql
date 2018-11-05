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
end