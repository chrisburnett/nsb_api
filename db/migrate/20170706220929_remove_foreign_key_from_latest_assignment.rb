class RemoveForeignKeyFromLatestAssignment < ActiveRecord::Migration[5.1]
  def change
    remove_foreign_key :jobs, :assignments
  end
end
