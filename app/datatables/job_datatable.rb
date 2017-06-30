class JobDatatable < AjaxDatatablesRails::Base

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format

    # NOTE: these columns must either exist directly on models or
    # refer to aliased columns in the (eventual) SQL query. 't4_r1' is
    # a name given automatically by the rails query generator. This is
    # probably unreliable and subject to change if the order of these
    # fields changes etc.
    @view_columns ||= {
      title: { source: "Job.short_title", cond: :like },
      tenant: { source: "Tenant.name", cond: :like },
      contractor: {source: "t4_r1", searchable: true, cond: filter_custom_column_condition },
      client: { source: "Client.name", cond: :like},
      status: { source: "Assignment.status", cond: :like }
    }
  end

  def data
    records.map do |job|
      {
        title: job.short_title,
        tenant: job.tenant.name,
        contractor: get_contractor_string(job),
        client: job.client.name,
        status: get_status_string(job)
      }
    end
  end

  private

  # functions to return correct result when there's no assignments,
  # otherwise table fails
  def get_contractor_string(job)
    if job.contractor.nil? then ""
    else job.contractor.name
    end
  end
  def get_status_string(job)
    if job.completed then "completed"
    elsif job.latest_assignment.nil? || job.latest_assignment.status.nil? then "unassigned"
    else job.latest_assignment.status || "pending" end
  end

  # performs the actual query backing the datatable
  def get_raw_records
    Job.includes(:user, :tenant, :client, :contractor).references(:user, :tenant, :client, :contractor, :assignment)
  end

  # required for search on custom column
  # contractors_jobs is the join table Rails creates that gets aliased to t4_r1
  def filter_custom_column_condition
    ->(term) { ::Arel::Nodes::SqlLiteral.new("\"contractors_jobs\".\"name\"").matches("%#{ term.search.value }%") }
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
