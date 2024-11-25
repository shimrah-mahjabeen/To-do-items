module Types
  class QueryType < Types::BaseObject
    field :tasks, [TaskType], null: false, description: "Retrieve all tasks or search tasks" do
      argument :status, String, required: false, description: "Filter tasks by status (pending or completed)"
      argument :due_date, GraphQL::Types::ISO8601DateTime, required: false, description: "Filter tasks created on or after this time"
      argument :page, Integer, required: false, default_value: 5
      argument :per_page, Integer, required: false, default_value: 1
    end

    field :task, TaskType, null: true do
      description "Retrieve a single task by ID"
      argument :id, ID, required: true
    end

    field :tasks_for_month, [Types::TaskType], null: false, description: "Fetch tasks for a specific month and year" do
      argument :user_id, ID, required: true, description: "ID of the user whose tasks will be fetched"
      argument :date, GraphQL::Types::ISO8601DateTime, required: true, description: "Date to filter tasks by month and year"
    end

    field :task_counts, Types::TaskCountsType, null: false, description: "Returns task counts for dashboard"

    def tasks(status: nil, due_date: nil, page: nil, per_page: nil)
      user = current_user
      tasks = user.tasks

      tasks = tasks.ransack(status_eq: status).result if status.present?
      tasks = tasks.where('due_on >= ?', due_date) if due_date.present?

      tasks = tasks.order(created_at: :desc).page(page).per(per_page)
      tasks
    end

    def task(id:)
      user = current_user
      task = user.tasks.find_by(id: id)

      raise GraphQL::ExecutionError, "Task not found" unless task

      task
    end

    def task_counts
      user = current_user

      total_tasks = user.tasks.count
      pending_tasks = user.tasks.in_progress.count
      completed_tasks = user.tasks.completed.count

      {
        total: total_tasks,
        pending: pending_tasks,
        completed: completed_tasks
      }
    end

    def tasks_for_month(user_id:, date:)
      start_of_month = date.beginning_of_month
      end_of_month = date.end_of_month

      tasks = Task.where(user_id: user_id, due_on: start_of_month..end_of_month)

      tasks
    rescue StandardError => e
      raise GraphQL::ExecutionError, "An error occurred: #{e.message}"
    end

    private

    def current_user
      context[:current_user]
    end
  end
end
