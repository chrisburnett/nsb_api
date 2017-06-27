class AddSignatureToAssignment < ActiveRecord::Migration[5.1]
  def change
    add_column :assignments, :signature, :string
  end
end
