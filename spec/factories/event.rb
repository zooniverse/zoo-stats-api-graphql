FactoryBot.define do
  factory :event do
    sequence(:event_id)       { |n| "100#{n}".to_i }
    sequence(:event_source)   { |n| "Server ##{n}" }
    sequence(:event_time)     { Time.now.round(0) }
    sequence(:event_type)     { "background" }

    factory :complete_event do
      sequence(:project_id)   { |n| "200#{n}".to_i }
      sequence(:workflow_id)  { |n| "300#{n}".to_i }
      sequence(:user_id)      { |n| "400#{n}".to_i }
      data { {"metadata" => "test"} }
    end
  end
end