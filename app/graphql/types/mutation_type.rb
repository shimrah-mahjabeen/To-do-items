# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :login_user, mutation: Mutations::LoginUser
    field :sign_up_user, mutation: Mutations::SignUpUser
    field :delete_task, mutation: Mutations::DeleteTask
    field :update_task, mutation: Mutations::UpdateTask
    field :update_task_status, mutation: Mutations::UpdateTaskStatus
    field :create_task, mutation: Mutations::CreateTask
  end
end
