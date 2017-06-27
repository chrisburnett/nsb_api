class JobDatatable < AjaxDatatablesRails::Base

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      title: { source: "Job.short_title", cond: :like },
      tenant: { source: "Job.tenant.id", cond: :eq },
      contractor: {source: "Job.latest_assignment.contractor.name", cond: :eq },
      status: { source: "Job.latest_assignment.id", cond: :eq },
    }
  end

  def data
    records.map do |record|
      {
        title: record.short_title,
        tenant: record.tenant.id,
        contractor: get_contractor_string(record),
        status: get_status_string(record),
      }
    end
  end

  private

  # functions to return correct result when there's no assignments,
  # otherwise table fails
  def get_contractor_string(record)
    if record.latest_assignment.nil? then ""
    else record.latest_assignment.contractor.name
    end
  end
  
  def get_status_string(record)
    if record.completed then "completed"
    elsif record.latest_assignment.nil? then "unassigned"
    else record.latest_assignment.status || "pending" end
  end

  def get_raw_records
    Job.includes(:tenant, :latest_assignment)
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
