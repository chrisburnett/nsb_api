class CreateTrades < ActiveRecord::Migration[5.1]
  def change
    create_table :trades do |t|
      t.string :name
      t.string :description
      t.text :notes

      t.timestamps
    end
  end
end
