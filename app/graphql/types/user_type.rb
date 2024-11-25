# app/graphql/types/user_type.rb
module Types
  class UserType < BaseObject
    field :id, ID, null: false
    field :email, String, null: false
    field :created_at, String, null: true
    field :updated_at, String, null: true
  end
end
  