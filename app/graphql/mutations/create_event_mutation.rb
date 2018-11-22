require_relative 'mutation_root'
require_relative 'transformers/panoptes_classification'

module Mutations
  class CreateEventMutation < Mutations::BaseMutation
    null true

    argument :event_payload, String, required: true

    field :errors, [String], null: false

    def resolve(event_payload:)
      # TODO: Add guard here to only ingest data that meets the schema
      # avoid ouroboros data and panoptes talk data until we have verified
      # the schema conformance here
      # return unless model.type && model.source == panoptes classificaiton
      
      # TODO: authorisation here
      if event_payload.nil?
        return {errors: [{"message" => "ArgumentError"}]}
      end
      
      prepared_payload = Transformers::PanoptesClassification.new(event_payload).transform
      event = Event.new(prepared_payload)
      if event.save
        {
          errors: []
        }
      else
        {
          errors: event.errors.full_messages
        }
      end
    end
  end
end