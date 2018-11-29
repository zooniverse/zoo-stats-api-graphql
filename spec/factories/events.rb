FactoryBot.define do
  factory :event do
    sequence(:event_id)     { |n| "100#{n}".to_i }
    sequence(:event_source) { |n| "Server ##{n}" }
    sequence(:event_time)   { Time.now.round(0) }
    sequence(:event_type)   { "background" }
    sequence(:project_id)   { |n| "200#{n}".to_i }
    sequence(:workflow_id)  { |n| "300#{n}".to_i }
    sequence(:user_id)      { |n| "400#{n}".to_i }
    data                    { {"metadata" => "test"} }
    session_time            { rand(1.0..10.0) }
    country_name "United Kingdom"
    country_code "GB"
    city_name "Oxford"
    latitude 51.75222
    longitude -1.25596
  end
end
