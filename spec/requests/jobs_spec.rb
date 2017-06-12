require 'rails_helper'

RSpec.describe 'Jobs API', type: :request do
  # initialize test data 
  let!(:jobs) { create_list(:job, 10) }
  let(:job_id) { jobs.first.id }

  # Test suite for GET /todos
  describe 'GET /api/jobs' do
    # make HTTP get request before each example
    before { get '/api/jobs' }

    it 'returns jobs' do
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /api/jobs/:id
  describe 'GET /api/jobs/:id' do
    before { get "/api/jobs/#{job_id}" }

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
      let(:job_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Job/)
      end
    end
  end

  # # Test suite for POST /api/jobs
  # describe 'POST /api/jobs' do
  #   # valid payload
    
  #   context 'when the request is valid' do
  #     let(:user) { create(:user) }
  #     let(:tenant) { create(:tenant) }
  #     before { post '/api/jobs', params: { user_id: user.id, tenant_id: tenant.id, short_title: 'Test', reported_date: "2014-03-03" } }

  #     it 'creates a job' do
  #       expect(json['short_title']).to eq('Test')
  #       expect(json['user_id']).to eq(user.id)
  #     end

  #     it 'returns status code 201' do
  #       expect(response).to have_http_status(201)
  #     end
  #   end

  #   context 'when the request is invalid' do
  #     before { post '/api/jobs', params: { title: 'Foobar' } }

  #     it 'returns status code 422' do
  #       expect(response).to have_http_status(422)
  #     end

  #     it 'returns a validation failure message' do
  #       expect(response.body)
  #         .to match(/Validation failed: User must exist, Tenant must exist, Short title can't be blank, Reported date can't be blank/)
  #     end
  #   end
  # end

  # Test suite for PUT /api/jobs/:id
  describe 'PUT /api/jobs/:id' do
    let(:valid_attributes) { { short_title: 'Sets' } }

    context 'when the record exists' do
      before { put "/api/jobs/#{job_id}", params: valid_attributes }

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  # Test suite for DELETE /api/jobs/:id
  # describe 'DELETE /api/jobs/:id' do
  #   before { delete "/api/jobs/#{job_id}" }

  #   it 'returns status code 204' do
  #     expect(response).to have_http_status(204)
  #   end
  # end
end
