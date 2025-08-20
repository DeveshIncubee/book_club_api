module Mutations
  class DeleteReview < BaseMutation
    argument :id, ID, required: true

    field :review, Types::ReviewType, null: true
    field :errors, [ String ], null: false

    def resolve(id:)
      review = Review.find(id)
      review.destroy

      { review:, errors: [] }
    end
  end
end
