FactoryBot.define do
  factory :event do
    sequence(:event_id) { |n| "100#{n}".to_i }
    sequence(:event_source) { |n| "Server ##{n}" }
    sequence(:event_time) { Time.now.round(6) }
  end
end