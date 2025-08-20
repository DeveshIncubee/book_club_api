module Mutations
  class UpdateReview < BaseMutation
    argument :id, ID, required: true
    argument :rating, Integer, required: true
    argument :comment, String, required: true

    field :review, Types::ReviewType, null: true
    field :errors, [ String ], null: false

    def resolve(id:, rating:, comment:)
      review = Review.find(id)
      Review.update(rating:, comment:)

      if review.save
        { review:, errors: [] }
      else
        { review: nil, errors: review.errors.full_messages }
      end
    end
  end
end
