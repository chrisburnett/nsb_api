class RemoveResponseDateFromAssignment < ActiveRecord::Migration[5.1]
  def change
    remove_column :assignments, :response_date
  end
end
