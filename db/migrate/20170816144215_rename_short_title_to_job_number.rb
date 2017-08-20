class RenameShortTitleToJobNumber < ActiveRecord::Migration[5.1]
  def change
    rename_column :jobs, :short_title, :job_number
  end
end
