class RenameShortTitleToJobNumber < ActiveRecord::Migration[5.1]
  def change
    rename_column :jobs, :job_number, :job_number
  end
end
