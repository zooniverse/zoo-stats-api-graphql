# frozen_string_literal: true

class GroupEventsDayController < ApplicationController
  def index
    # look at adding a pagination solution, perhaps combined with a serializer..
    # we don't need format of json-api https://github.com/stas/jsonapi.rb
    # but we do like the pagination, sorting and filtering functions
    events_scope = GroupEventsDay.all
    render json: EventsSerializer.new(events_scope), serializer_options: serializer_opts_from_params

    # end
  end

  def show
    events_scope = GroupEventsDay.where(group_id: params[:id])
    render json: EventsSerializer.new(events_scope), serializer_options: serializer_opts_from_params
  end

  private

  def serializer_opts_from_params
    { limit: params[:limit], order: params[:order] }
  end
end
