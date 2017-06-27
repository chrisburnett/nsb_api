class AddLatestAssignmentToJobs < ActiveRecord::Migration[5.1]
  def change
    add_column :jobs, :latest_assignment_id, :integer
    add_foreign_key :jobs, :assignments, column: :latest_assignment_id
  end
end
