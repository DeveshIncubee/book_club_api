module Resolvers
  class GetUser < BaseResolver
    type Types::UserType, null: false
    description "Fetch a user given its ID."

    argument :id, ID, required: true, description: "ID of the user."

    def resolve(id:)
      User.find(id)
    end
  end
end
