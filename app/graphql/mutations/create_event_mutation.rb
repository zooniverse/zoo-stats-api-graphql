require_relative 'mutation_root'

module Mutations
  class CreateEvent < Mutation::BaseMutation
    null true

    argument :event_payload, String, required: true

    field :event, Event, null: true
    field :errors, [String], null: false

    def resolve(event_payload:)
      model = Models.for(event_payload)
      event = Event.build(event_details(model))
      # TODO: authorisation here
      if event.save
        {
          event: event,
          errors: [],
        }
      else
        {
          event: nil,
          errors: event.errors.full_messages
        }
      end
    end

    private

    def event_details(model)
      attributes = model.attributes

      [
        event_id:        model.id,
        event_type:      model.type,
        event_source:    model.source,
        event_time:      model.time,
        project_id:      attributes.project_id,
        workflow_id:     attributes.workflow_id,
        user_id:         attributes.user_id,
        data:            remaining_data(model),
        session_time:    session_time(model)
      ]
    end
    
    def remaining_data(model)
      # TODO: do we want to store the metadata or the diff of the data minus what we have?
      # attributes.data - attributes already in payload
    end

    def session_time(model)
      metadata = model.dig('data','metadata')
      started_at = started_at['started_at']
      finished_at = started_at['finished_at']

      # TODO: convert these to time objects
      # taking into account the TZ info in the string
      # and subtracting them to find the diff

    end
  end
end