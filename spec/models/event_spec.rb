RSpec.describe Event, type: :model do
  it 'has a valid factory' do
    expect(build(:event)).to be_valid
  end

  describe 'model validations' do
    let(:attributes) do
      {
        event_id: 123,
        event_source: 'Panoptes',
        event_time: Time.zone.rfc3339('2018-10-02T13:16:37Z'),
        event_type: 'classification'
      }
    end
    let(:event) { create(:event, **attributes) }

    %i(event_id event_source event_time event_type).each do |name|
      it 'validates the chosen attributes' do
        expect(event).to allow_value(attributes[name]).for(name)
        expect(event).to validate_presence_of(name)
      end
    end

    it 'has composite primary key' do
      expect(Event.find([
        attributes[:event_id],
        attributes[:event_type],
        attributes[:event_source],
        attributes[:event_time]
        ])).to eq(event)
    end
  end

  describe "upsert" do
    let(:event) { build(:event) }

    let(:upsert_pk_keys) do
      {
        event_id: event.event_id,
        event_type: event.event_type,
        event_source: event.event_source,
        event_time: event.event_time
      }
    end

    it "should insert a new record if none exists for the primary key" do
      expect{ event.upsert }.to change { Event.count }.from(0).to(1)
    end

    it "should overwrite an existing record when upserting" do
      event.save
      new_data_payload = { data: { "metadata" => "update_test" } }
      updated_event_data = upsert_pk_keys.merge(new_data_payload)
      new_upsert_event = build(:event, updated_event_data)
      expect{ new_upsert_event.upsert }.not_to change { Event.count }
      expect(new_upsert_event.reload.data).to eq(new_data_payload[:data])
    end
  end
end
