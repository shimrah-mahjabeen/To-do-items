module Mutations
  class LoginUser < BaseMutation
    argument :email, String, required: true
    argument :password, String, required: true

    field :user, Types::UserType, null: true
    field :token, String, null: true
    field :errors, [String], null: false

    def resolve(email:, password:)
      user = User.find_by(email: email)

      if user&.valid_password?(password)
        # Generate JWT token for the user after successful login
        token = JwtService.encode(user_id: user.id)
        { user: user, token: token, errors: [] }
      else
        { user: nil, token: nil, errors: ['Invalid email or password'] }
      end
    end
  end
end
