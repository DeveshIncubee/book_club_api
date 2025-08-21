module Resolvers
  class GetBook < BaseResolver
    type Types::BookType, null: false
    description "Fetch a book given its ID."

    argument :id, ID, required: true, description: "ID of the book."

    def resolve(id:)
      Book.find(id)
    end
  end
end
