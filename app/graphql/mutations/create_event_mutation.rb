require_relative 'mutation_root'
require_relative 'transformers'

module Mutations
  class CreateEventMutation < Mutations::BaseMutation
    null true

    argument :event_payload, String, required: true, description: 'array of event object in json string format'

    field :errors, [String], null: false

    def resolve(event_payload:)
      raise GraphQL::ExecutionError, "Unauthorized" unless authenticate?
      raise GraphQL::ExecutionError, "Permission denied" unless authorised?

      if event_payload.empty?
        return { errors: [{"message" => "ArgumentError"}] }
      end

      # use a set to filter the incoming events to be unique
      # based on their AR id hash, which in turn uses
      # the composite primary key, same as upserts 🎉
      # https://github.com/rails/rails/blob/e69ff43060c1194d2a3bd9b8d9e23f3ae26b84b5/activerecord/lib/active_record/core.rb#L432
      events_list = Set.new
      event_json = JSON.parse(event_payload)
      # TODO: Add guard here to only ingest data that meets the schema
      # avoid ouroboros data and panoptes talk data until we have verified
      # the schema conformance here
      # return unless model.type && model.source == panoptes classificaiton
      event_json.each do |event|
        prepared_payload = Transformers.for(event).transform
        events_list.add(Event.new(prepared_payload))
      end

      Event.transaction do
        Event.import!(
          events_list.to_a, # have to pass array object for bulk import, https://github.com/zdennis/activerecord-import/issues/680
          on_duplicate_key_update: {
            conflict_target: %i(event_id event_type event_source event_time),
            columns: %i(project_id workflow_id user_id data session_time country_name country_code city_name latitude longitude)
          }
        )
      end
      # Note: any import errors above will raise now
      # (500 response) for the incoming mutation request
      #
      # Using 500 response status is not idomatic graphql
      # but it is the easiest way to handle the lamdba function error processing
      # as it stands, https://github.com/zooniverse/zoo-stats-api-graphql/blob/965ac156ad38281458fe347fdf9be5a21249db6d/kinesis-to-http/zoo-stats-api-graphql.py#L20
      #
      # Noting that graphql end points will return 200 even for errored states
      # https://graphql-ruby.org/mutations/mutation_errors
      # https://github.com/rmosolgo/graphql-ruby/blob/master/guides/errors/execution_errors.md
      #
      # the following error payloads ast it stands is useless now
      # but is a placeholder to convert to errors as data in futur
      # and modification of the lambda function result handler
      # to check the response payloads for error states
      { errors: [] }
    end

    private

    def authenticate?
      context[:basic_user] && context[:basic_password]
    end

    def authorised?
      if desired_username.present? || desired_password.present?
        context[:basic_user] == desired_username && context[:basic_password] == desired_password
      end
    end

    def desired_username
      if Rails.env.production?
        Rails.application.credentials.mutation_username_production
      else
        Rails.application.credentials.mutation_username_staging
      end
    end

    def desired_password
      if Rails.env.production?
        Rails.application.credentials.mutation_password_production
      else
        Rails.application.credentials.mutation_password_staging
      end
    end
  end
end
