# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GroupEventsDay', type: :request do
  describe 'GET /counts/day/groups' do
    before do
      get group_events_day_path
    end

    it 'returns a success response status', :focus do
      binding.pry
      expect(response.status).to eq(200)
    end

    # it 'returns results in the expected schema' do
    #   binding.pry

    #   expect(response.status).to eq(200)
    # end
  end
end
