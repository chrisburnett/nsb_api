class CreateItems < ActiveRecord::Migration[5.1]
  def change
    create_table :items do |t|
      t.string :sor_code
      t.text :description
      t.float :quantity
      t.references :job, foreign_key: true

      t.timestamps
    end
  end
end
