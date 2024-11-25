module Mutations
  class UpdateTask < BaseMutation
    argument :id, ID, required: true
    argument :title, String, required: false
    argument :description, String, required: false
    argument :due_on, GraphQL::Types::ISO8601DateTime, required: false

    field :task, Types::TaskType, null: true
    field :errors, [String], null: false

    def resolve(id:, title: nil, description: nil, due_on: nil)
      current_user = context[:current_user]

      task = current_user.tasks.find_by(id: id)
      return { task: nil, errors: ["Task not found"] } unless task

      update_attributes = {}
      update_attributes[:title] = title if title.present?
      update_attributes[:description] = description if description.present?
      update_attributes[:due_on] = due_on if due_on.present?

      if task.update(update_attributes)
        { task: task, errors: [] }
      else
        { task: nil, errors: task.errors.full_messages }
      end
    end
  end
end

