require 'rails_helper'

RSpec.describe 'Assignments API', type: :request do
  # initialize test data
  let!(:user) { create(:user) }
  let!(:job1) { create(:job, completed: false) }
  let!(:job2) { create(:job, completed: true) }
  let!(:pending_assignments) { create_list(:assignment, 10, status: "pending", user: user, contractor: user) }
  let!(:assignments) { create_list(:assignment, 5, status: "accepted", user: user, contractor: user) }
  let!(:completed_assignments) { create_list(:assignment, 10, job: job2, user: user, contractor: user) }
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

    it 'returns 30 assignments' do
      expect(json.length).to eq(25)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # test scope of assignments which are assigned and accepted
  describe 'GET /api/v1/assignments?active=true' do
    before { get "/api/v1/assignments?active=true", headers: header }

    context 'when requesting only open assignments' do
      it 'returns only open assignments' do
        expect(json.length).to eq(5)
        expect(json[0]['active']).to be_truthy
      end
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
  # Test suite for PUT /api/v1/assignments/:id
  describe 'PUT /api/v1/assignments/:id' do
    let(:valid_attributes) { { am_pm_visit: 'am_pm_visit' } }
    let(:other_assignment) { create(:assignment) }
    let(:new_assignment) { create(:assignment, user: user, contractor: user) }

    context 'when the record exists' do
      before { put "/api/v1/assignments/#{assignment_id}", params: valid_attributes, headers: header }

      it 'updates the record' do
        expect(response.body).to be_empty
      end
      
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    context 'when the assignment concerns someone else' do
      before { put "/api/v1/assignments/#{other_assignment.id}", params: valid_attributes, headers: header }
      it 'returns http code 403 forbidden' do
        expect(response).to have_http_status(403)
      end
    end

    context 'when the assignment is accepted' do
      before { put "/api/v1/assignments/#{new_assignment.id}", params: { status: "accepted" }, headers: header }
      before { get "/api/v1/assignments/#{new_assignment.id}", headers: header}
      it 'sets the status to accepted' do
        expect(json['status']).to eq("accepted")
      end

      it 'sets the job status to assigned' do
        expect(json['job']['assigned']).to be_truthy
      end

      it 'retains the id of the user who accepted the assignment', versioning: true do
        puts job1.versions.last.whodunnit
      end
    end
    context 'when the assignment is rejected' do
      before { put "/api/v1/assignments/#{new_assignment.id}", params: { status: "rejected" }, headers: header }
      before { get "/api/v1/assignments/#{new_assignment.id}", headers: header}
      it 'sets the status to rejected', versioning: true do
        expect(json['status']).to eq("rejected")
      end

      it 'sets the job status to unassigned' do
        expect(json['job']['assigned']).to be_falsey
      end
    end
    
    context 'when an assignment status is invalid' do
      before { put "/api/v1/assignments/#{new_assignment.id}", params: { status: "rubbish" }, headers: header }
      
      it 'returns response code 422' do
        expect(response).to have_http_status(422)
      end
    end
    
  end
end
