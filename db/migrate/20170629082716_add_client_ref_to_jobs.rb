class AddClientRefToJobs < ActiveRecord::Migration[5.1]
  def change
    add_reference :jobs, :client, foreign_key: true
  end
end
