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
        if name.empty?
          { user: nil, errors: [ "Name cannot be empty" ] }
        elsif email.empty?
          { user: nil, errors: [ "Email cannot be empty" ] }
        elsif email.match?(URI::MailTo::EMAIL_REGEXP) == false
          { user: nil, errors: [ "Provide valid email" ] }
        elsif User.where(email:).any?
          { user: nil, errors: [ "Email has already been taken" ] }
        else
          { user: nil, errors: user.errors.full_message }
        end
      end
    end
  end
end
