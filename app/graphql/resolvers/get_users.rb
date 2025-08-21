module Resolvers
  class GetUsers < BaseResolver
    type [ Types::UserType ], null: false
    description "Return a list of users"

    argument :limit, Integer, required: false, description: "Limit of the users.", default_value: 4

    def resolve(limit:)
      User.limit(limit)
    end
  end
end
