RSpec.describe Event, type: :model do
  it 'has a valid factory' do
    expect(build(:event)).to be_valid
  end

  let(:attributes) do
    {
      event_id: 123,
      event_source: 'Panoptes',
      event_time: Time.zone.rfc3339('2018-10-02T13:16:37Z')
    }
  end

  let!(:event) { create(:event, **attributes) }

  describe 'model validations' do
    it { expect(event).to allow_value(attributes[:event_id]).for(:event_id) }
    it { expect(event).to validate_presence_of(:event_id) }

    it { expect(event).to allow_value(attributes[:event_source]).for(:event_source) }
    it { expect(event).to validate_presence_of(:event_source) }

    it { expect(event).to allow_value(attributes[:event_time]).for(:event_time) }
    it { expect(event).to validate_presence_of(:event_time) }

    it 'has composite primary key' do
      expect(Event.find([
        attributes[:event_id],
        attributes[:event_source],
        attributes[:event_time]
        ])).to eq(event)
    end
  end
end
