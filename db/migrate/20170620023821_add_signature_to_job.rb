class AddSignatureToJob < ActiveRecord::Migration[5.1]
  def change
    add_column :jobs, :signature, :string
  end
end
