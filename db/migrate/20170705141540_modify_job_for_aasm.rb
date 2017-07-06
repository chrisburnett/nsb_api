class ModifyJobForAasm < ActiveRecord::Migration[5.1]
  def change
    remove_column :jobs, :completed
    add_column :jobs, :status, :string
  end
end
