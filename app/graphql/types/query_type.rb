# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :users, [ Types::UserType ], null: false, description: "Return a list of users" do
      argument :limit, Integer, required: false, description: "Limit of the users.", default_value: 4
    end

    def users(limit:)
      User.limit(limit)
    end

    field :user, Types::UserType, null: true, description: "Fetch a user given its ID." do
      argument :id, ID, required: true, description: "ID of the user."
    end

    def user(id:)
      User.find(id)
    end

    field :books, [ Types::BookType ], null: false, description: "Return a list of books." do
      argument :limit, Integer, required: false, description: "Limit of the books.", default_value: 8
    end

    def books(limit:)
      Book.limit(limit)
    end

    field :book, Types::BookType, null: true, description: "Fetch a book given its ID." do
      argument :id, ID, required: true, description: "ID of the book."
    end

    def book(id:)
      Book.find(id)
    end
  end
end
