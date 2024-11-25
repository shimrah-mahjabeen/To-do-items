module Mutations
    class UpdateTaskStatus < BaseMutation
      argument :id, ID, required: true
      argument :status, String, required: true
  
      field :success, Boolean, null: false
      field :error, String, null: true
      field :id, ID, null: true
  
      def resolve(id:, status:)
        current_user = context[:current_user]
  
        task = current_user.tasks.find_by(id: id)
  
        if task.nil?
          return {
            success: false,
            error: "Task not found",
            id: nil
          }
        end
  
        if task.update(status: status)
          {
            success: true,
            error: nil,
            id: task.id
          }
        else
          {
            success: false,
            error: task.errors.full_messages.join(", "),
            id: task.id
          }
        end
      end
    end
  end