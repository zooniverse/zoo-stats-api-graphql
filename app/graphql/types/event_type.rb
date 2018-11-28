module Types
  class EventType < GraphQL::Schema::Object
    description 'The Event type'
    field :event_id, ID, null: false,
    description: "Event ID"
    field :event_type, String, null: false,
    description: "Type of event (classification, comment, ...)"
    field :event_time, GraphQL::Types::ISO8601DateTime, null: false,
    description: "Timestamp of event"
    field :event_source, String, null: false,
    description: "Source of event"
    field :session_time, Float, null: true,
    description: "Elapsed time for the event"
    field :user_id, ID, null: true,
    description: "User ID"
    field :project_id, ID, null: true,
    description: "Project ID"
    field :workflow_id, ID, null: true,
    description: "Workflow ID under project"
    field :data, String, null: true,
    description: "Extra event metadata"
    field :country_name, String, null: true,
    description: "User country name"
    field :country_code, String, null: true,
    description: "User country code"
    field :city_name, String, null: true,
    description: "User city name"
    field :latitude, Int, null: true,
    description: "User latitude"
    field :longitude, Int, null: true,
    description: "User longitude"
    field :period, GraphQL::Types::ISO8601DateTime, null: true,
    description: "Output time slot"
    field :count, Int, null: true,
    description: "Output event count"
  end
end