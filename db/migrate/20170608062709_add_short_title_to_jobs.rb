class AddShortTitleToJobs < ActiveRecord::Migration[5.1]
  def change
    add_column :jobs, :job_number, :string
  end
end
