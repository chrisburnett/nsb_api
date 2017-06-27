class RemoveItemFieldsFromJob < ActiveRecord::Migration[5.1]
  def change
    remove_column :jobs, :sor_code
    remove_column :jobs, :description
  end
end
