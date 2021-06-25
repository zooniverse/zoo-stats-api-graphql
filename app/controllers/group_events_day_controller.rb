# frozen_string_literal: true

class GroupEventsDayController < ApplicationController
  def index
    limit = params[:per_page] || 100
    # keep the limit sane
    clamped_limit = limit.clamp(0, 500)
    # look at adding a pagination solution, perhaps combined with a serializer..
    # we don't need format of json-api https://github.com/stas/jsonapi.rb
    # but we do like the pagination, sorting and filtering functions
    # .....TBD
    render json: GroupEventsDay.order(period: :asc).limit(clamped_limit).as_json
  end
end
