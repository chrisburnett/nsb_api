class ChangeReportedDateToDate < ActiveRecord::Migration[5.1]
  def change
    change_column :jobs, :reported_date, :date
  end
end
