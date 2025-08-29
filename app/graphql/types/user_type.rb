# frozen_string_literal: true

module Types
  class UserType < Types::BaseObject
    field :id, ID, null: false
    field :name, String
    field :email, String
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :reviews, [ Types::ReviewType ], null: true

    def reviews
      Loaders::AssociationLoader.for(User, :reviews).load(object)
    end

    field :events, [ Types::EventType ], null: true

    def events
      Loaders::AssociationLoader.for(User, :events).load(object)
    end

    field :attended_events, [ Types::EventType ], null: true

    def attended_events
      Loaders::AssociationLoader.for(User, :attended_events).load(object)
    end
  end
end
