# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GroupEventsDay', type: :request do
  describe 'GET /counts/day/groups' do
    let(:event) { create(:group_event, event_time: Time.now - 1.day) }
    let(:another_event) { create(:group_event) }
    let(:event_day) { Time.zone.parse(event.event_time.to_date.to_s) }
    let(:another_event_day) { Time.zone.parse(another_event.event_time.to_date.to_s) }
    let(:formatted_events) do
      [
        { period: event_day, group_id: event.group_id, count: 1 },
        { period: another_event_day, group_id: another_event.group_id, count: 1 }
      ]
    end

    before do
      event
      another_event
    end

    it 'returns a success response status' do
      get group_events_day_index_path
      expect(response.status).to eq(200)
    end

    it 'returns results in the expected JSON schema format' do
      expected_results = { events_over_time: { buckets: formatted_events } }
      get group_events_day_index_path
      expect(response.body).to eq(expected_results.to_json)
    end

    it 'respects the limit param' do
      expected_results = { events_over_time: { buckets: [{ period: event_day, group_id: event.group_id, count: 1 }] } }
      get group_events_day_index_path, params: { limit: 1 }
      expect(response.body).to eq(expected_results.to_json)
    end

    it 'respects the order param' do
      expected_results = { events_over_time: { buckets: formatted_events.reverse } }
      get group_events_day_index_path, params: { order: :desc }
      expect(response.body).to eq(expected_results.to_json)
    end
  end

  describe 'GET /counts/day/groups/:id' do
    let(:event) { create :group_event }
    before do
      event
      _another_group_event = create(:group_event)
      get group_events_day_path(event.group_id)
    end

    it 'returns a success response status' do
      expect(response.status).to eq(200)
    end

    it 'returns results in the expected JSON schema' do
      event_day = Time.zone.parse(event.event_time.to_date.to_s)
      expected_results = { events_over_time: { buckets: [{ period: event_day, group_id: event.group_id, count: 1 }] } }
      expect(response.body).to eq(expected_results.to_json)
    end
  end
end
