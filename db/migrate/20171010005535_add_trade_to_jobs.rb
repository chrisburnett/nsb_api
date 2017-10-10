class AddTradeToJobs < ActiveRecord::Migration[5.1]
  def change
    add_column :jobs, :trade, :string
  end
end
