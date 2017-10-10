class ChangeAssignmentTimeTypes < ActiveRecord::Migration[5.1]
  def change
    change_column :assignments, :scheduled_hour, :string
    change_column :assignments, :scheduled_minute, :string
  end
end
