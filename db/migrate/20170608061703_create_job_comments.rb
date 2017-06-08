class CreateJobComments < ActiveRecord::Migration[5.1]
  def change
    create_table :job_comments do |t|
      t.references :job, foreign_key: true
      t.references :user, foreign_key: true
      t.text :comment_text

      t.timestamps
    end
  end
end
