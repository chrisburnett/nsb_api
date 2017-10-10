class AddMinuteToAssignment < ActiveRecord::Migration[5.1]
  def change
    add_column :assignments, :minute, :integer
  end
end
