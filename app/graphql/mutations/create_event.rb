module Mutations
  class CreateEvent < BaseMutation
    argument :title, String, required: true
    argument :description, String, required: true
    argument :location, String, required: true
    argument :starts_at, GraphQL::Types::ISO8601DateTime, required: true
    argument :ends_at, GraphQL::Types::ISO8601DateTime, required: true
    argument :user_id, ID, required: true

    field :event, Types::EventType, null: true
    field :errors, [ String ], null: false

    def resolve(title:, description:, location:, starts_at:, ends_at:, user_id:)
      event = Event.create(title:, description:, location:, starts_at:, ends_at:, user_id:)

      if event.save
        { event:, errors: [] }
      else
        if title.empty?
          { event: nil, errors: [ "Title cannot be empty" ] }
        else
          { event: nil, errors: event.errors.full_messages }
        end
      end
    end
  end
end
