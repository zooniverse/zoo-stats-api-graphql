RSpec.describe Event, type: :model do
  it 'has a valid factory' do
    expect(build(:event)).to be_valid
  end

  let(:attributes) do
    {
      event_id: 123,
      event_source: 'Panoptes',
      event_time: Time.zone.rfc3339('2018-10-02T13:16:37Z'),
      event_type: 'classification'
    }
  end

  let!(:event) { create(:event, **attributes) }

  describe 'model validations' do
    [
      :event_id,
      :event_source,
      :event_time,
      :event_type
    ].each do |name|
      it 'validates the chosen attributes' do
        expect(event).to allow_value(attributes[name]).for(name)
        expect(event).to validate_presence_of(name)
      end
    end

    it 'has composite primary key' do
      expect(Event.find([
        attributes[:event_id],
        attributes[:event_type]
        attributes[:event_source],
        attributes[:event_time],
        ])).to eq(event)
    end
  end
end
