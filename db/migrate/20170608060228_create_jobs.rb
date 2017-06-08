class CreateJobs < ActiveRecord::Migration[5.1]
  def change
    create_table :jobs do |t|
      t.datetime :reported_date
      t.datetime :completed_date
      t.text :reported_fault
      t.text :sor_code
      t.text :description
      t.text :notes
      t.string :status
      t.references :tenant, foreign_key: true
      t.references :user, foreign_key: true
    end
  end
end
