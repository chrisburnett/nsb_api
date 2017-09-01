class AddInvoiceNumberToJobs < ActiveRecord::Migration[5.1]
  def change
    add_column :jobs, :invoice_number, :string
  end
end
