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

    def stats_count(query_filters, searcher=Searchers::Bucket)
      if Authorizer.new(query_filters, context).allowed?
        searcher.search(**query_filters)
      else
        raise GraphQL::ExecutionError, "Permission denied"

      end
    end

    private

    class Authorizer
      attr_reader :query_filter_keys, :user_id_filter, :logged_in_user_id, :logged_in_admin_user
      SITE_WIDE_FILTERS = %i(user_id workflow_id project_id).freeze

      def initialize(query_filters, context)
        @query_filter_keys = query_filters.keys
        @user_id_filter = query_filters[:user_id]
        @logged_in_user_id = context[:current_user]&.to_s
        @logged_in_admin_user = context.fetch(:admin, false)
      end

      def allowed?
        return true if logged_in_admin_user

        return false if site_wide_search?

        return false if user_filter_differs_to_logged_in_user?

        # filters conform to rules let it through
        true
      end

      private

      # non-admins must filter on at least one filter key
      def site_wide_search?
        (SITE_WIDE_FILTERS & query_filter_keys).empty?
      end

      # all filtering on user_id must be for the logged in user
      def user_filter_differs_to_logged_in_user?
        if user_id_filter
          logged_in_user_id != user_id_filter
        else
          false
        end
      end
    end
  end
end
