require 'rails_helper'

RSpec.describe 'BatchUpdate API', type: :request do

  # initialize test data 
  let!(:user) { create(:user) }
  let!(:job1) { create(:job, contractor: user) }
  let!(:job2) { create(:job, contractor: user) }
  
  describe 'PUT /admin/batch_update_invoice_numbers' do
    it 'updates the invoice number' do
      params = {jobs: [{ jobnumber: job1.job_number, invoicenumber: "abc123" },
                       { jobnumber: job2.job_number, invoicenumber: "123abc" }]}
      put '/admin/batch_update_invoice_numbers', params: params
      expect(response).to have_http_status(200)
      expect(Job.find_by(job_number: job1.job_number).invoice_number).to eq("abc123")
      expect(Job.find_by(job_number: job2.job_number).invoice_number).to eq("123abc")
    end
  end    
end
