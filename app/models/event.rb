class Event < ApplicationRecord
  self.primary_keys = :event_id, :event_type, :event_source, :event_time
  validates :event_id, presence: true
  validates :event_type, presence: true
  validates :event_source, presence: true
  validates :event_time, presence: true
end
