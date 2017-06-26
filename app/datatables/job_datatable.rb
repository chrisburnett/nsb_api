class JobDatatable < AjaxDatatablesRails::Base

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      title: { source: "Job.short_title", cond: :like },
      tenant: { source: "Job.tenant.id", cond: :eq },
      status: { source: "Job.status", cond: :eq }
    }
  end

  def data
    records.map do |record|
      {
        title: record.short_title,
        tenant: record.tenant.id,
        status: record.status
      }
    end
  end

  private

  def get_raw_records
    Job.includes(:tenant)
  end

  # ==== These methods represent the basic operations to perform on records
  # and feel free to override them

  # def filter_records(records)
  # end

  # def sort_records(records)
  # end

  # def paginate_records(records)
  # end

  # ==== Insert 'presenter'-like methods below if necessary
end
