module Mutations
  class UpdateUser < BaseMutation
    argument :id, ID, required: true
    argument :name, String, required: false
    argument :email, String, required: false

    field :user, Types::UserType, null: true
    field :errors, [ String ], null: false

    def resolve(id:, **args)
      allowed_keys = [ :name, :email ]
      unexpected_keys = args.keys - allowed_keys

      if unexpected_keys.any?
        return { user: nil, errors: [ "Unsupported arguments provided" ] }
      end

      user = User.find(id)
      user.update(args)

      if user.save
        { user:, errors: [] }
      else
        if args.include?(:name) && args[:name].empty?
          { user: nil, errors: [ "Name cannot be empty" ] }
        elsif args.include?(:email)
          if args[:email].empty?
            { user: nil, errors: [ "Email cannot be empty" ] }
          elsif args[:email].match?(URI::MailTo::EMAIL_REGEXP) == false
            { user: nil, errors: [ "Provide valid email" ] }
          end
        else
          { user: nil, errors: user.errors.full_messages }
        end
      end
    end
  end
end
