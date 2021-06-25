# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GroupEventsDay', type: :request do
  fdescribe 'GET /counts/day/groups' do
    let(:event) { create :group_event }
    before do
      event
      get group_events_day_index_path
    end

    it 'returns a success response status' do
      expect(response.status).to eq(200)
    end

    it 'returns results in the expected JSON schema' do
      event_day = Time.zone.parse(event.event_time.to_date.to_s)
      expected_results = [{ period: event_day, group_id: event.group_id, count: 1 }]
      expect(response.body).to eq(expected_results.to_json)
    end
  end
end
