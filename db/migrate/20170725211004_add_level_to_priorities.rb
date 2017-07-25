class AddLevelToPriorities < ActiveRecord::Migration[5.1]
  def change
    add_column :priorities, :level, :integer
  end
end
