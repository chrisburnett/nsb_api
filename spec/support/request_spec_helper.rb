# spec/support/request_spec_helper
module RequestSpecHelper
  # Parse JSON response to ruby hash
  def json
    JSON.parse(response.body)
  end

  def authenticated_header(user_id, admin)
    token = Authentication::AuthToken.encode({ user_id: user_id, admin: admin })
    { 'Authorization': "Bearer #{token}" }
  end
end
