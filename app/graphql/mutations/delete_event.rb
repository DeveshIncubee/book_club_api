module Mutations
  class DeleteEvent < BaseMutation
    argument :id, ID, required: true

    field :event, Types::EventType, null: true
    field :errors, [ String ], null: false

    def resolve(id:)
      event = Event.find(id)
      event.destroy

      { event:, errors: [] }
    end
  end
end
