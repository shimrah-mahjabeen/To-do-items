# frozen_string_literal: true

module Types
    class TaskType < Types::BaseObject
      field :id, ID, null: false
      field :title, String
      field :description, String
      field :status, Integer
      field :user_id, Integer
      field :due_on, GraphQL::Types::ISO8601DateTime, null: false
      field :created_at, GraphQL::Types::ISO8601DateTime, null: false
      field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    end
  end
  