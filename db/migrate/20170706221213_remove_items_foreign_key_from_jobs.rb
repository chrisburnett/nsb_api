class RemoveItemsForeignKeyFromJobs < ActiveRecord::Migration[5.1]
  def change
    remove_foreign_key :items, :jobs
  end
end
