class CreateTenants < ActiveRecord::Migration[5.1]
  def change
    create_table :tenants do |t|
      t.string :name
      t.string :address
      t.text :notes

      t.timestamps
    end
  end
end
