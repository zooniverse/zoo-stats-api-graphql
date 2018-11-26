require_relative '../mutations/create_event_mutation'

module Types
  class MutationType < Types::BaseObject
    field :create_event, mutation: Mutations::CreateEventMutation, description: 'Add events to database'
  end
end