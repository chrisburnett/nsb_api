class RemovePriorityFromJobs < ActiveRecord::Migration[5.1]
  def change
    remove_column :jobs, :priority
  end
end
