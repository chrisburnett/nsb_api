class AddPriorityReferenceToJobs < ActiveRecord::Migration[5.1]
  def change
    add_reference :jobs, :priority, foreign_key: true
  end
end
