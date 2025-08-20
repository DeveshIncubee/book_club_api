module Mutations
  class CreateReview < BaseMutation
    argument :rating, Integer, required: true
    argument :comment, String, required: true
    argument :user_id, ID, required: true
    argument :book_id, ID, required: true

    field :review, Types::ReviewType, null: true
    field :errors, [ String ], null: false

    def resolve(rating:, comment:, user_id:, book_id:)
      review = Review.create(rating:, comment:, user_id:, book_id:)

      if review.save
        { review:, errors: [] }
      else
        { review: nil, errors: review.errors.full_messages }
      end
    end
  end
end
