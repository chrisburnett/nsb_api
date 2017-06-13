class AddAssignedToJobs < ActiveRecord::Migration[5.1]
  def change
    add_column :jobs, :assigned, :boolean
  end
end
