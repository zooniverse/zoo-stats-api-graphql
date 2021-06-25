# frozen_string_literal: true

# AR model over the 'group_events_day' continuous aggregate view
# to ease the sql query formation
class GroupEventsDay < ApplicationRecord
  self.table_name = 'group_events_day'
  # save rails from failing if save is called (not strictly necessary)
  def readonly?
    true
  end

  # example queries
  #
  # SQL
  #     SELECT * FROM group_events_day order by period ASC LIMIT 1;
  #
  # ActiveRecord
  #     GroupEventsDay.where(group_id: 124).order(period: :asc)
  #     GroupEventsDay.where(group_id: 124).where("period >= ?", "2021-06-18").order(period: :asc)
end
