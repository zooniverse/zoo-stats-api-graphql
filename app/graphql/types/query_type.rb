require_relative "../utilities/searchers.rb"

module Types
  class QueryType < Types::BaseObject
    description 'The query root of this schema'

    field :stats_count, [Types::EventType], null: false do
      description 'returns counts of event types grouped by interval (e.g. "1 day") with optional filtering by user, project and workflow ids'
      argument :interval, String, required: true
      argument :event_type, String, required: true
      argument :user_id, ID, required: false
      argument :project_id, ID, required: false
      argument :workflow_id, ID, required: false
    end

    def stats_count(kwargs, searcher=Searchers::Bucket)
      if site_wide_search_and_not_admin?(kwargs) || user_search_and_not_user?(kwargs[:user_id])
        raise GraphQL::ExecutionError, "Permission denied"
      else
        searcher.search(**kwargs)
      end
    end

    private

    def site_wide_search_and_not_admin?(arguments)
      site_wide_search?(arguments) && (not context[:admin])
    end
    
    def site_wide_search?(arguments)
      not (arguments[:user_id] || arguments[:project_id] || arguments[:workflow_id])
    end

    def user_search_and_not_user?(query_id)
      query_id && (not user_permission?(query_id))
    end

    def user_permission?(query_id)
      context[:admin] || context[:current_user].to_s == query_id
    end
  end
end