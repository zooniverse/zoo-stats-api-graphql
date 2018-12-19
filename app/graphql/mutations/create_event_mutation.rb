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

      events_list = []
      event_json = JSON.parse(event_payload)
      # TODO: Add guard here to only ingest data that meets the schema
      # avoid ouroboros data and panoptes talk data until we have verified
      # the schema conformance here
      # return unless model.type && model.source == panoptes classificaiton
      event_json.each do |event|
        prepared_payload = Transformers.for(event).transform
        events_list.append(Event.new(prepared_payload))
      end

      errors = []

      begin
        Event.transaction do
          Event.import!(
            events_list,
            on_duplicate_key_update: {
              conflict_target: %i(event_id event_type event_source event_time),
              columns: %i(project_id workflow_id user_id data session_time country_name country_code city_name latitude longitude)
            }
          )
        end
      rescue ActiveRecord::StatementInvalid
        errors << 'Payload contains duplicate rows'
      end

      { errors: errors }
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
