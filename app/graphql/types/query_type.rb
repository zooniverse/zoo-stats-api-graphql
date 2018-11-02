require_relative "../event/complete_search.rb"

module Types
  class QueryType < Types::BaseObject
    description 'The query root of this schema'

    field :user_id_query, [Types::EventType], null: false do
      description 'returns all events with user_id'
      argument :userId, ID, required: true
    end

    def user_id_query(kwargs, searcher=Searchers::Complete)
      searcher.new.search(**kwargs)
    end

    field :project_id_query, [Types::EventType], null: false do
      description 'returns all events with project_id'
      argument :project_id, ID, required: true
    end

    def project_id_query(kwargs, searcher=Searchers::Complete)
      searcher.new.search(**kwargs)
    end
  end
end