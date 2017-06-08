class CreateAssignments < ActiveRecord::Migration[5.1]
  def change
    create_table :assignments do |t|
      t.references :user, foreign_key: true
      t.references :job, foreign_key: true
      t.date :assignment_date
      t.string :am_pm_visit
      t.text :resolution
      t.text :notes

      t.timestamps
    end
  end
end
