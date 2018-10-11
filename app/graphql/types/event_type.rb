module Types
  class EventType < GraphQL::Schema::Object
    description 'The Event type'
    # event specific fields
    field :event_id, ID, null: false,
    description: "Event ID"
    field :event_type, String, null: true,
    description: "Type of event (classification, comment, ...)"
    field :event_time, GraphQL::Types::ISO8601DateTime, null: false,
    description: "Timestamp of event"
    field :event_created_at, GraphQL::Types::ISO8601DateTime, null: true,
    description: "Time database entry created"
    field :event_source, String, null: false,
    description: "Source of event"
    
    # user fields
    field :user_id, ID, null: true,
    description: "User ID"
    field :user_zooniverse_id, ID, null: true,
    description: "Global user ID"
    field :zooniverse_id, ID, null: true,
    description: "Global ID"
    field :lang, String, null: true,
    description: "Client language"
    field :user_agent, String, null: true,
    description: "Client web-browser info"
    field :user_name, String, null: true,
    description: "Zooniverse username"
    
    # project fields
    field :project_id, ID, null: true,
    description: "Project ID"
    field :project_name, String, null: true,
    description: "Project name"
    field :workflow_id, ID, null: true,
    description: "Workflow ID under project"
    field :subject_ids, String, null: true,
    description: "Subject ID under project"
    field :subject_urls, String, null: true,
    description: "Urls for each subject"
    
    # discussion board fields
    field :board_id, ID, null: true,
    description: "Board ID"
    field :board, String, null: true,
    description: "Board name"
    field :discussion_id, ID, null: true,
    description: "Discussion ID"
    field :focus, String, null: true,
    description: "Comment focus"
    field :focus_id, ID, null: true,
    description: "Focus ID"
    field :focus_type, String, null: true,
    description: "Comment focus type"
    field :section, String, null: true,
    description: "Comment section"
    field :body, String, null: true,
    description: "Body of comment"
    field :url, String, null: true,
    description: "Url for comment"
    field :tags, String, null: true,
    description: "Comment tags"
  end
end