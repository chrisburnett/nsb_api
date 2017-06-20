require 'rails_helper'

RSpec.describe 'JobsComments API', type: :request do
  # initialize test data
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:job) { create(:job) }
  let!(:comments) { create_list(:job_comment, 2, user: user, job: job) }
  let!(:other_comment) { create(:job_comment, user: other_user, job: job )}
  let!(:header) { authenticated_header(user.id, false) }

  # Test suite for GET /api/jobs/:id
  describe 'GET /api/v1/jobs/:id/comments' do
    before { get "/api/v1/jobs/#{job.id}/comments", headers: header }

    context 'when the job has comments' do
      it 'returns all the job comments' do
        expect(json.length).to eq(3)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

  end

  # Test suite for PUT /api/jobs/:id
  describe 'POST /api/v1/jobs/:job_id/comments/:id' do
    let(:valid_attributes) { { user_id: user.id, comment_text: "booooo" } } # router should pass in job_id
    
    context 'when the record exists' do
      before { post "/api/v1/jobs/#{job.id}/comments", params: valid_attributes, headers: header }

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end
  end

  describe 'DELETE /api/v1/jobs/:job_id/comments/:id' do
    context 'when the comment exists' do
      it 'deletes the comment' do
        # do a get request, should be 404
        delete "/api/v1/jobs/#{job.id}/comments/#{comments[0].id}", headers: header
        get "/api/v1/jobs/#{job.id}/comments/#{comments[0].id}", headers: header
        expect(response).to have_http_status(404)
      end
    end

    context 'when the comment belongs to someone else' do
      it 'returns forbidden' do
        delete "/api/v1/jobs/#{job.id}/comments/#{other_comment.id}", headers: header
        expect(response).to have_http_status(403)
      end
    end
  end
  
end
