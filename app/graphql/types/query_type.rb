# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :users, [ Types::UserType ], null: false, description: "Return a list of users" do
      argument :limit, Integer, required: false, description: "Limit of the users.", default_value: 4
    end

    def users(limit:)
      User.limit(limit)
    end

    field :user, Types::UserType, null: true, description: "Fetches a user given its ID." do
      argument :id, ID, required: true, description: "ID of the user."
    end

    def user(id:)
      User.find(id)
    end
  end
end
