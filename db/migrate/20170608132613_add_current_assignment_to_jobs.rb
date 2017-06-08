class AddCurrentAssignmentToJobs < ActiveRecord::Migration[5.1]
  def change
    add_column :jobs, :current_assignment, :integer
    add_foreign_key :jobs, :assignments, column: :current_assignment
  end
end
