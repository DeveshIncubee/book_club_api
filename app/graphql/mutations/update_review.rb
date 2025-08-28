module Mutations
  class UpdateReview < BaseMutation
    argument :id, ID, required: true
    argument :rating, Integer, required: false
    argument :comment, String, required: false

    field :review, Types::ReviewType, null: true
    field :errors, [ String ], null: false

    def resolve(id:, **args)
      allowed_keys = [ :rating, :comment ]
      unexpected_keys = args.keys - allowed_keys

      if unexpected_keys.any?
        return { review: nil, errors: [ "Unsupported arguments provided" ] }
      end

      if args.include?(:rating) && (1..5).exclude?(args[:rating])
        return { review: nil, errors: [ "Rating must be between 1 and 5" ] }
      end

      if args.include?(:comment) && args[:comment].empty?
        return { review: nil, errors: [ "Comment cannot be empty" ] }
      end

      review = Review.find(id)
      Review.update(args)

      if review.save
        # Important: reload the record so graphql-batch doesn't return a stale version
        review.reload
        { review:, errors: [] }
      else
        { review: nil, errors: review.errors.full_messages }
      end
    end
  end
end
