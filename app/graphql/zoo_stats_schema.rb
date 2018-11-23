class ZooStatsSchema < GraphQL::Schema
  rescue_from(ActiveRecord::RecordInvalid) do |error|
    error.message
  end

  mutation(Types::MutationType)
  query(Types::QueryType)
end
