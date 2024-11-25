module Mutations
  class DeleteTask < BaseMutation
    argument :id, ID, required: true

    field :id, ID, null: true
    field :success, Boolean, null: false
    field :errors, [String], null: false

    def resolve(id:)
      current_user = context[:current_user]

      task = current_user.tasks.find_by(id: id)
      if task&.destroy
        { id: id, success: true, errors: [] }
      else
        { id: id, success: false, errors: ["Task not found or could not be deleted"] }
      end
    end
  end
end