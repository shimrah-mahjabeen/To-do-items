
module Mutations
  class CreateTask < BaseMutation
    argument :title, String, required: true
    argument :description, String, required: false
    argument :status, String, required: true
    argument :due_on, GraphQL::Types::ISO8601DateTime, required: true

    field :task, Types::TaskType, null: true
    field :errors, [String], null: false

    def resolve(title:, description: nil, due_on:, status:)
      current_user = context[:current_user]

      task = current_user.tasks.new(title: title, description: description, status: status, due_on: due_on)
      if task.save
        { task: task, errors: [] }
      else
        { task: nil, errors: task.errors.full_messages }
      end
    end
  end
end
