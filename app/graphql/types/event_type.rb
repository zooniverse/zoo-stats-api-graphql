module Types
  class EventType < GraphQL::Schema::Object
    description 'The Event type'
    # event specific fields
    field :event_id, ID, null: false
    field :event_type, String, null: true
    field :event_time, GraphQL::Types::ISO8601DateTime, null: false
    field :event_created_at, GraphQL::Types::ISO8601DateTime, null: true
    field :event_source, String, null: false
    
    # user fields
    field :user_id, ID, null: true,
    description: "User ID"
    field :user_zooniverse_id, ID, null: true,
    description: "Global user ID"
    field :zooniverse_id, ID, null: true,
    description: "Global ID"
    field :lang, String, null: true
    field :user_agent, String, null: true
    field :user_name, String, null: true
    
    # project fields
    field :project_id, ID, null: true
    field :project_name, String, null: true
    field :workflow_id, ID, null: true
    field :subject_ids, String, null: true
    field :subject_urls, String, null: true
    
    # discussion board fields
    field :board_id, ID, null: true
    field :board, String, null: true
    field :discussion_id, ID, null: true
    field :focus, String, null: true
    field :focus_id, ID, null: true
    field :focus_type, String, null: true
    field :section, String, null: true
    field :body, String, null: true
    field :url, String, null: true
    field :tags, String, null: true
  end
end