require_relative "../utilities/searchers.rb"

module Types
  class QueryType < Types::BaseObject
    description 'The query root of this schema'

    field :user_stats_count, [Types::EventType], null: false do
      description 'returns counts of events by user in category grouped into period with length of interval (i.e. "1 day")'
      argument :user_id, ID, required: true
      argument :event_type, String, required: true
      argument :interval, String, required: true
    end

    def user_stats_count(kwargs, searcher=Searchers::Bucket)
      if user_permission?(kwargs[:user_id])
        searcher.search(**kwargs)
      else
        raise GraphQL::ExecutionError, "Permission denied"
      end
    end

    field :project_stats_count, [Types::EventType], null: false do
      description 'returns counts of events by project in category grouped into period with length of interval (i.e. "1 day")'
      argument :project_id, ID, required: true
      argument :event_type, String, required: true
      argument :interval, String, required: true
    end

    def project_stats_count(kwargs, searcher=Searchers::Bucket)
      searcher.search(**kwargs)
    end

    private

    def user_permission?(query_id)
      context[:admin] || context[:current_user].to_s == query_id
    end
  end
end