class AddPriorityToJob < ActiveRecord::Migration[5.1]
  def change
    add_column :jobs, :priority, :string
  end
end
