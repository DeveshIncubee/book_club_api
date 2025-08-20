module Mutations
  class CreateUser < BaseMutation
    argument :name, String, required: true
    argument :email, String, required: true

    field :user, Types::UserType, null: true
    field :errors, [ String ], null: false

    def resolve(name:, email:)
      user = User.new(name:, email:)
      if user.save
        { user:, errors: [] }
      else
        { user: nil, errors: user.errors.full_message }
      end
    end
  end
end
