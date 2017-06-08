class ChangeTenantAddressType < ActiveRecord::Migration[5.1]
  def change
    change_column :tenants, :address, :text
  end
end
