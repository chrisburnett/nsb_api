require 'rails_helper'

RSpec.describe 'Jobs API', type: :request do
  # initialize test data 
  let!(:jobs) { create_list(:job, 10) }
  let(:job_id) { jobs.first.id }

  # Test suite for GET /todos
  describe 'GET /jobs' do
    # make HTTP get request before each example
    before { get '/jobs' }

    it 'returns jobs' do
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /jobs/:id
  describe 'GET /jobs/:id' do
    before { get "/jobs/#{job_id}" }

    context 'when the record exists' do
      it 'returns the job' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(job_id)
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

  # # Test suite for POST /jobs
  # describe 'POST /jobs' do
  #   # valid payload
  #   let(:valid_attributes) { { title: 'Learn Elm', created_by: '1' } }

  #   context 'when the request is valid' do
  #     before { post '/jobs', params: valid_attributes }

  #     it 'creates a job' do
  #       expect(json['title']).to eq('Learn Elm')
  #     end

  #     it 'returns status code 201' do
  #       expect(response).to have_http_status(201)
  #     end
  #   end

  #   context 'when the request is invalid' do
  #     before { post '/jobs', params: { title: 'Foobar' } }

  #     it 'returns status code 422' do
  #       expect(response).to have_http_status(422)
  #     end

  #     it 'returns a validation failure message' do
  #       expect(response.body)
  #         .to match(/Validation failed: Created by can't be blank/)
  #     end
  #   end
  # end

  # Test suite for PUT /jobs/:id
  # describe 'PUT /jobs/:id' do
  #   let(:valid_attributes) { { title: 'Shopping' } }

  #   context 'when the record exists' do
  #     before { put "/jobs/#{job_id}", params: valid_attributes }

  #     it 'updates the record' do
  #       expect(response.body).to be_empty
  #     end

  #     it 'returns status code 204' do
  #       expect(response).to have_http_status(204)
  #     end
  #   end
  # end

  # Test suite for DELETE /jobs/:id
  describe 'DELETE /jobs/:id' do
    before { delete "/jobs/#{job_id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
