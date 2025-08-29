# frozen_string_literal: true

module Types
  class EventType < Types::BaseObject
    field :id, ID, null: false
    field :title, String, null: false
    field :description, String, null: false
    field :location, String, null: false
    field :starts_at, GraphQL::Types::ISO8601DateTime, null: false
    field :ends_at, GraphQL::Types::ISO8601DateTime, null: false
    field :user_id, Integer, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
