class Event < ApplicationRecord
  validates :event_id, presence: true
  validates :event_source, presence: true
  validates :event_time, presence: true
end
