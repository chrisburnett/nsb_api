require 'rails_helper'

RSpec.describe 'Jobs API', type: :request do
  # initialize test data 
  let!(:jobs) { create_list(:job, 5, assigned: true, assignment_count: 3) }
  let!(:available_jobs) { create_list(:job, 5, assigned: false, assignment_count: 3) }
  let(:job_id) { jobs.first.id }

  # Test suite for GET /todos
  describe 'GET /api/v1/jobs' do
    # make HTTP get request before each example
    before { get '/api/v1/jobs' }

    it 'returns jobs' do
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /api/jobs/:id
  describe 'GET /api/v1/jobs/:id' do
    before { get "/api/v1/jobs/#{job_id}" }

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
        get "/api/v1/jobs/fail"
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        get "/api/v1/jobs/fail"
        expect(response.body).to match(/Couldn't find Job/)
      end
    end
  end

  describe 'GET /api/v1/jobs/?available=true' do
    before { get "/api/v1/jobs?available=true"}

    it 'returns only available jobs' do
      expect(json.size).to eq(5)
    end
  end

  # Test suite for PUT /api/jobs/:id
  describe 'PUT /api/v1/jobs/:id' do
    let(:valid_attributes) { { completed: true } }

    context 'when the record exists' do
      before { put "/api/v1/jobs/#{job_id}", params: valid_attributes }

      it 'updates the record' do
        get "/api/v1/jobs/#{job_id}"
        expect(json['completed']).to be_truthy
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end
end
