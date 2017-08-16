class AddDueDateToJobs < ActiveRecord::Migration[5.1]
  def change
    add_column :jobs, :due_date, :date
  end
end
