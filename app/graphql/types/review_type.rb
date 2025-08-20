# frozen_string_literal: true

module Types
  class ReviewType < Types::BaseObject
    field :id, ID, null: false
    field :rating, Integer
    field :comment, String
    field :user_id, Integer, null: false
    field :book_id, Integer, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :user, Types::UserType, null: false

    def user
      Loaders::RecordLoader.for(User).load(object.user_id)
    end

    field :book, Types::BookType, null: false

    def book
      Loaders::RecordLoader.for(Book).load(object.book_id)
    end
  end
end
