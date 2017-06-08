class AddDatesToAssignments < ActiveRecord::Migration[5.1]
  def change
    add_column :assignments, :scheduled_date, :date
    add_column :assignments, :actual_date, :date
  end
end
