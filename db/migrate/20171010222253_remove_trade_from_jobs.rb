class RemoveTradeFromJobs < ActiveRecord::Migration[5.1]
  def change
    remove_column :jobs, :trade
  end
end
