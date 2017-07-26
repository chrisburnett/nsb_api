class AddContactDetailsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :email, :string
    add_column :users, :phone_number, :string
  end
end
