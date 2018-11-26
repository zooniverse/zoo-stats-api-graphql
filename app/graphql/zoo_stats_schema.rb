class ZooStatsSchema < GraphQL::Schema
  rescue_from(ActiveRecord::RecordInvalid) { |error| error.message }

  mutation(Types::MutationType)
  query(Types::QueryType)
end
