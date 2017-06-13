require 'rails_helper'

RSpec.describe 'Assignments API', type: :request do
  # initialize test data 
  let!(:assignment) { create(:assignment) }
  let(:assignment_id) { assignment.id }

  # Test suite for GET /todos
  describe 'GET /api/v1/assignments' do
    # make HTTP get request before each example
    before { get '/api/v1/assignments' }

    it 'returns ' do
      expect(json).not_to be_empty
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /api/v1/assignments/:id
  describe 'GET /api/v1/assignments/:id' do
    before { get "/api/v1/assignments/#{assignment_id}" }

    context 'when the record exists' do
      it 'returns the assignment' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(assignment_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:assignment_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Assignment/)
      end
    end
  end

  # # Test suite for POST /api/v1/assignments
  describe 'POST /api/v1/assignments' do
    # valid payload
    
    context 'when the request is valid' do
      let(:user) { create(:user) }
      let(:job) { create(:job) }
      before { post '/api/v1/assignments', params: { user_id: user.id, job_id: job.id, assignment_date: "2014-03-03" } }

      it 'creates an assignment' do        
        expect(json['job_id']).to eq(job.id)
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/api/v1/assignments', params: { titlea: 'Foobar' } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Validation failed: User must exist, Job must exist, Assignment date can't be blank/)
      end
    end
  end

  # Test suite for PUT /api/v1/jobsnts/:id
  describe 'PUT /api/v1/assignments/:id' do
    let(:valid_attributes) { { assignment_date: '2014-04-04' } }

    context 'when the record exists' do
      before { put "/api/v1/assignments/#{assignment_id}", params: valid_attributes }

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  # Test suite for DELETE /api/v1/assignments/:id
  # describe 'DELETE /api/v1/assignments/:id' do
  #   before { delete "/api/v1/assignments/#{assignment_id}" }

  #   it 'returns status code 204' do
  #     expect(response).to have_http_status(204)
  #   end
  # end
end
