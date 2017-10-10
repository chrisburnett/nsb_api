class AddIndexToJobs < ActiveRecord::Migration[5.1]
  def change
    add_index :jobs, :job_number
  end
end
