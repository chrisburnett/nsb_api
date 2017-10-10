class ChangeAssignmentDateToDateOnly < ActiveRecord::Migration[5.1]
  def change
    change_column :assignments, :assignment_date, :date
  end
end
