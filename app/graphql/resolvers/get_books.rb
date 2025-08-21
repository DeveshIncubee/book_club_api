module Resolvers
  class GetBooks < BaseResolver
    type [ Types::BookType ], null: false
    description "Return a list of books"

    argument :limit, Integer, required: false, description: "Limit of the books.", default_value: 8

    def resolve(limit:)
      Book.limit(limit)
    end
  end
end
