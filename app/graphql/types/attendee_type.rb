# frozen_string_literal: true

module Types
  class AttendeeType < Types::BaseObject
    field :id, ID, null: false
    field :user_id, Integer, null: false
    field :event_id, Integer, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :user, Types::UserType, null: false

    def user
      Loaders::RecordLoader.for(User).load(object.user_id)
    end

    field :event, Types::EventType, null: false

    def event
      Loaders::RecordLoader.for(Event).load(object.event_id)
    end
  end
end
