class RemoveCurrentAssignmentFromJobs < ActiveRecord::Migration[5.1]
  def change
    remove_column :jobs, :current_assignment
  end
end
