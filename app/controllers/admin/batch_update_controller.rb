class Admin::BatchUpdateController < ActionController::Base

  def update_invoice_numbers
    job_params = params[:jobs]
    job_params.each do |job_update|
      job = Job.find_by(job_number: job_update[:jobnumber])
      job.update(invoice_number: job_update[:invoicenumber])
    end
    head :ok
  end
  
end
