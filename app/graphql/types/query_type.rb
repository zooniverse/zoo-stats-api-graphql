require_relative "../utilities/searchers.rb"

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

    field :user_stats_count, [Types::EventType], null: false do
      description 'returns counts of events by user in category grouped into period with length of interval (i.e. "1 day")'
      argument :user_id, ID, required: true
      argument :event_type, String, required: true
      argument :interval, String, required: true
    end

    def user_stats_count(kwargs, searcher=Searchers::Bucket)
      searcher.new.search(**kwargs)
    end

    field :project_stats_count, [Types::EventType], null: false do
      description 'returns counts of events by project in category grouped into period with length of interval (i.e. "1 day")'
      argument :project_id, ID, required: true
      argument :event_type, String, required: true
      argument :interval, String, required: true
    end

    def project_stats_count(kwargs, searcher=Searchers::Bucket)
      searcher.new.search(**kwargs)
    end
  end
end