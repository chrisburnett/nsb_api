class ChangeAssignmentDateType < ActiveRecord::Migration[5.1]
  def change
    change_column :assignments, :assignment_date, :datetime
  end
end
