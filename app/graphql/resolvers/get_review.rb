module Resolvers
  class GetReview < BaseResolver
    type Types::ReviewType, null: false
    description "Fetch a review given its ID."

    argument :id, ID, required: true, description: "ID of the review."

    def resolve(id:)
      Review.find(id)
    end
  end
end
