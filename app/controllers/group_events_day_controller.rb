# frozen_string_literal: true

class GroupEventsDayController < ApplicationController
  def index
    # look at adding a pagination solution, perhaps combined with a serializer..
    # we don't need format of json-api https://github.com/stas/jsonapi.rb
    # but we do like the pagination, sorting and filtering functions
    # .....TBD
    render json: GroupEventsDay.order(period: :asc).limit(clamped_limit).as_json
  end

  def show
    render json: GroupEventsDay.where(group_id: params[:id]).order(period: :asc).limit(clamped_limit).as_json
  end

  private

  def clamped_limit
    limit = params[:per_page] || 100
    # keep the limit sane
    limit.clamp(0, 500)
  end
end
