module Types
  class QueryType < Types::BaseObject
    description 'The query root of this schema'
    field :user_id_query, [Types::EventType], null: false do
      description 'returns all events with user_id'
      argument :userId, ID, required: true
    end

    def user_id_query(user_id:)
      Event.where(user_id: user_id)
    end

    field :project_id_query, [Types::EventType], null: false do
      description 'returns all events with project_id'
      argument :project_id, ID, required: true
    end

    def project_id_query(project_id:)
      Event.where(project_id: project_id)
    end
  end
end