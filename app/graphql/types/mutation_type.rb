module Types
  class MutationType < Types::BaseObject
    # TODO: remove me
    field :testfield, String, null: false do
      description "An example field added by the generator"
      argument :testarg, String, required: true
    end

    def testfield
      Event.create
      "Success"
    end
  end
end