class AddShortTitleToJobs < ActiveRecord::Migration[5.1]
  def change
    add_column :jobs, :short_title, :string
  end
end
