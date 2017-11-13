class JobDatatable < AjaxDatatablesRails::Base

  def_delegators :@view, :admin_job_url, :admin_job_assignment_url, :edit_admin_job_url, :edit_admin_job_assignment_url, :admin_job_assignments_url, :new_admin_job_assignment_url, :duplicate_admin_job_url

  def initialize(view, params)
    @params = params
    super(view)
  end
  
  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format

    # NOTE: these columns must either exist directly on models or
    # refer to aliased columns in the (eventual) SQL query. 't4_r1' is
    # a name given automatically by the rails query generator. This is
    # probably unreliable and subject to change if the order of these
    # fields changes etc.
    @view_columns ||= {
      jobnumber: { source: "Job.job_number", cond: :like },
      reported_date: { source: "Job.reported_date" },
      trade: { source: "Trade.name", cond: :like },
      tenant: { source: "Tenant.address", cond: :like },
      contractor: {source: "t4_r1", searchable: true, cond: filter_custom_column_condition },
      client: { source: "Client.name", cond: :like},
      status: { source: "Assignment.status", cond: :like }
    }
  end

  def data
    data = records.map do |job|
      assignment_id = job.latest_assignment.id if job.latest_assignment
      {
        '0': nil,
        jobnumber: job.job_number,
        reported_date: job.reported_date.to_formatted_s(:uk), 
        trade: job.trade ? job.trade.name : nil,
        tenant: job.tenant.address,
        contractor: get_contractor_string(job),
        client: job.client.name,
        status: get_status_string(job),
        admin_job_url: admin_job_url(job.id),
        duplicate_admin_job_url: duplicate_admin_job_url(job.id),
        edit_job_url: edit_admin_job_url(job.id),
        admin_assignment_url: assignment_id ? admin_job_assignment_url(job_id: job.id, id: assignment_id) : nil,
        new_assignment_url: new_admin_job_assignment_url(job_id: job.id),
        edit_assignment_url: assignment_id ? edit_admin_job_assignment_url(job_id: job.id, id: assignment_id) : nil,
        may_cancel: job.latest_assignment&.may_cancel? || false,
        may_complete: job.may_complete?,
        may_reopen: job.may_reopen?,
        may_assign: job.may_assign?,
        may_invoice: job.may_invoice?
      }
    end
    return data
  end

  private

  # functions to return correct result when there's no assignments,
  # otherwise table fails
  def get_contractor_string(job)
    if job.contractor.nil? then ""
    else job.contractor.name
    end
  end

  # formats the actual status code for the view
  def get_status_string(job)
    status_string = job.status.dup
    status_string << ": #{job.latest_assignment&.status}" unless
      job.status == Job::STATE_COMPLETED.to_s ||
      job.latest_assignment.nil? ||
      job.latest_assignment&.status == Assignment::STATE_FULFILLED.to_s
    return status_string
  end

  # performs the actual query backing the datatable
  def get_raw_records
    # expecting statuses to be a JSON array
    if(@params[:statuses]) then
      jobs = Proc.new { Job.where(status: @params[:statuses]) }
    else
      jobs = Proc.new { Job }
    end
    jobs.call.includes(:user, :trade, :tenant, :client, :contractor, ).references(:user, :trade,:tenant, :client, :contractor, :assignment).all
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
