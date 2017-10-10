class Admin::BatchUpdateController < ActionController::Base

  def update_invoice_numbers
    job_params = params[:jobs]
    job_params.each do |job_update|
      jobs = Job.where(job_number: job_update[:jobnumber])
      jobs.each do |job| job.update(invoice_number: job_update[:invoicenumber]) end
    end
    head :ok
  end
  
end
