class RemoveAssignedFromJobs < ActiveRecord::Migration[5.1]
  def change
    remove_column :jobs, :assigned
  end
end
