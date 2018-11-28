require_relative "../utilities/searchers.rb"

module Types
  class QueryType < Types::BaseObject
    description 'The query root of this schema'

    field :stats_count, [Types::EventType], null: false do
      description 'returns counts of events in category grouped into period with length of interval (i.e. "1 day")'
      argument :interval, String, required: true
      argument :event_type, String, required: true
      argument :user_id, ID, required: false
      argument :project_id, ID, required: false
      argument :workflow_id, ID, required: false
    end

    def stats_count(kwargs, searcher=Searchers::Bucket)
      if site_wide_search?(kwargs) && (not context[:admin])
        raise GraphQL::ExecutionError, "Permission denied"
      end
      if (not kwargs[:user_id]) || user_permission?(kwargs[:user_id])
        searcher.search(**kwargs)
      else
        raise GraphQL::ExecutionError, "Permission denied"
      end
    end

    private

    def user_permission?(query_id)
      context[:admin] || context[:current_user].to_s == query_id
    end

    def site_wide_search?(arguments)
      not (arguments[:user_id] || arguments[:project_id] || arguments[:workflow_id])
    end
  end
end