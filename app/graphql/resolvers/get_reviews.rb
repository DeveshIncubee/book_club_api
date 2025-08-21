module Resolvers
  class GetReviews < BaseResolver
    type [ Types::ReviewType ], null: false
    description "Return a list of reviews."

    argument :limit, Integer, required: false, description: "Limit of the reviews.", default_value: 8

    def resolve(limit:)
      Review.limit(limit)
    end
  end
end
