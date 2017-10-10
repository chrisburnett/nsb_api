class AddHourToAssignment < ActiveRecord::Migration[5.1]
  def change
    add_column :assignments, :hour, :integer
  end
end
