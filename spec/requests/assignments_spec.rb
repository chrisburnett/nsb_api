require 'rails_helper'

RSpec.describe 'Assignments API', type: :request do
  # initialize test data
  let!(:user) { create(:user) }
  let!(:job1) { create(:job, assigned: true, completed: false) }
  let!(:job2) { create(:job, assigned: false, completed: true) }
  let!(:assignments) { create_list(:assignment, 10, job: job1, user: user) }
  let!(:completed_assignments) { create_list(:assignment, 10, job: job2, user: user) }
  let!(:assignment_id) { assignments.first.id }
  let!(:header) { authenticated_header(user.id, false) }

  # access without token returns 401 unauthorized
  describe 'GET /api/v1/assignments' do
    before { get '/api/v1/assignments' }

    it 'returns status code 401' do
      expect(response).to have_http_status(401)
    end
  end
  
  # Test suite for GET /todos
  describe 'GET /api/v1/assignments' do
    # make HTTP get request before each example
    before { get '/api/v1/assignments', headers: header }

    it 'returns ' do
      expect(json).not_to be_empty
    end

    it 'returns 20 assignments' do
      expect(json.length).to eq(20)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /api/v1/assignments/:id
  describe 'GET /api/v1/assignments/:id' do
    before { get "/api/v1/assignments/#{assignment_id}", headers: header }

    context 'when the record exists' do
      it 'returns the assignment' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(assignment_id)
      end

      it 'returns the assignment including job details' do
        expect(json['job']).not_to be_empty
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
    end

  end

  # test scope of assignments with jobs which are open
  describe 'GET /api/v1/assignments?active=true' do
    before { get "/api/v1/assignments?active=true", headers: header }

    context 'when requesting only open assignments' do
      it 'returns only open assignments' do
        expect(json.length).to eq(1)
        expect(json[0]['active']).to be_truthy
      end
    end

  end

  # # Test suite for POST /api/v1/assignments
  describe 'POST /api/v1/assignments' do
    # valid payload
    
    context 'when the request is valid' do
      let(:job) { create(:job, assigned: false) }
      before { post '/api/v1/assignments', params: { job_id: job.id }, headers: header }

      it 'creates an assignment' do        
        expect(json['job_id']).to eq(job.id)
        expect(json['assignment_date']).not_to be_nil
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end

      it 'updates the associated job' do
        get "/api/v1/jobs/#{job.id}", headers: header
        expect(json['assigned']).to be_truthy
      end
    end

    context 'when the request is invalid' do
      before { post '/api/v1/assignments', params: { titlea: 'Foobar' }, headers: header }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

    end
  end

  # Test suite for PUT /api/v1/assignments/:id
  describe 'PUT /api/v1/assignments/:id' do
    let(:valid_attributes) { { am_pm_visit: 'am_pm_visit' } }
    let(:other_assignment) { create(:assignment) }
    context 'when the record exists' do
      before { put "/api/v1/assignments/#{assignment_id}", params: valid_attributes, headers: header }

      it 'updates the record' do
        expect(response.body).to be_empty
      end
      
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    context 'when the record belongs to someone else' do
      before { put "/api/v1/assignments/#{other_assignment.id}", params: valid_attributes, headers: header }
      it 'returns http code 403 forbidden' do
        expect(response).to have_http_status(403)
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
