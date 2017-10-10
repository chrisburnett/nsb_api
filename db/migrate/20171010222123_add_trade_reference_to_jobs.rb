class AddTradeReferenceToJobs < ActiveRecord::Migration[5.1]
  def change
    add_reference :jobs, :trade, foreign_key: true
  end
end
