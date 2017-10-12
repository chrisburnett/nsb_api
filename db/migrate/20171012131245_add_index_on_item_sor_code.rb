class AddIndexOnItemSorCode < ActiveRecord::Migration[5.1]
  def change
    add_index :items, :sor_code
  end
end
