class AddPhoneNumbersToTenants < ActiveRecord::Migration[5.1]
  def change
    add_column :tenants, :contact_number_1, :string
    add_column :tenants, :contact_number_2, :string
    add_column :tenants, :contact_number_3, :string
  end
end
