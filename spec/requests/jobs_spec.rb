require 'rails_helper'

RSpec.describe 'Jobs API', type: :request do
  # initialize test data
  let!(:user) { create(:user) }
  let!(:assignments) { create_list(:assignment, 5, user: user, contractor: user) }
  let(:job_id) { assignments.first.job.id }
  let(:header) { authenticated_header(user.id, false) }
  # Test suite for GET /todos
  describe 'GET /api/v1/jobs' do
    # make HTTP get request before each example
    before { get '/api/v1/jobs', headers: header }

    it 'returns jobs' do
      expect(json).not_to be_empty
      expect(json.size).to eq(5)
      expect(json[1]["items"].size).to eq(2)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /api/jobs/:id
  describe 'GET /api/v1/jobs/:id' do
    before { get "/api/v1/jobs/#{job_id}", headers: header }

    context 'when the record exists' do
      it 'returns the job' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(job_id)
      end

      it 'returns the job with an assignment' do
        expect(json['assignments']).not_to be_empty
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      it 'returns status code 404' do
        get "/api/v1/jobs/fail", headers: header
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        get "/api/v1/jobs/fail", headers: header
        expect(response.body).to match(/Couldn't find Job/)
      end
    end
  end

  # Test suite for PUT /api/jobs/:id
  describe 'PUT /api/v1/jobs/:id' do
    let(:valid_attributes) { { job_number: "booooo" } }
    
    context 'when the record exists' do
      before { put "/api/v1/jobs/#{job_id}", params: valid_attributes, headers: header }

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "PUT /api/v1/jobs/:job_id/" do
    
    context 'when the job is completed' do
      let(:header) { authenticated_header(user.id, false) }

      before { put "/api/v1/jobs/#{job_id}", headers: header, params: { job_number: "booooo", status: Job::STATE_COMPLETED.to_s } }
      
      it 'changes the job status to completed' do
        get "/api/v1/jobs/#{job_id}", headers: header
        expect(json['status']).to eq(Job::STATE_COMPLETED.to_s)
      end
      
      it 'returns http status 200' do
        expect(response).to have_http_status(200)
      end

      it 'maintains the identity of the user who updated the job' do
        who = Job.find(job_id).versions.last.whodunnit
        expect(who).to eq(user.id.to_s)
      end
      
    end
  end
end
