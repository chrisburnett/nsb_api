class RenameAssignmentTimeFie < ActiveRecord::Migration[5.1]
  def change
    rename_column :assignments, :hour, :scheduled_hour
    rename_column :assignments, :minute, :scheduled_minute
  end
end
