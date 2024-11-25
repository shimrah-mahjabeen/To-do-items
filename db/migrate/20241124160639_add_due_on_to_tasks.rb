class AddDueOnToTasks < ActiveRecord::Migration[7.0]
  def change
    add_column :tasks, :due_on, :date, null: true
  end
end
