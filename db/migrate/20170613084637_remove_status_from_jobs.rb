class RemoveStatusFromJobs < ActiveRecord::Migration[5.1]
  def change
    remove_column :jobs, :status
  end
end