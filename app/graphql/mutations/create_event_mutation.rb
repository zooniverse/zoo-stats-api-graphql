require_relative 'mutation_root'
require_relative 'transformers/panoptes_classification'

module Mutations
  class CreateEventMutation < Mutations::BaseMutation
    null true

    argument :event_payload, [String], required: true, description: 'list of events in json format'

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
      
      events_list = []
      event_payload.each do |event|
        event_hash = eval(event)
        prepared_payload = Transformers::PanoptesClassification.new(event_hash).transform
        events_list.append(Event.new(prepared_payload))
      end

      events_list.each do |event|
        return { errors: event.errors.full_messages } unless event.save
      end
      { errors: [] }
    end
  end
end