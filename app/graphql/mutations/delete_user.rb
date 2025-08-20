module Mutations
  class DeleteUser < BaseMutation
    argument :id, ID, required: true

    field :user, Types::UserType, null: true
    field :errors, [ String ], null: false

    def resolve(id:)
      user = User.find(id)
      user.destroy

      { user:, errors: [] }
    end
  end
end
