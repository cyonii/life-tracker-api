require 'rails_helper'

RSpec.describe 'api/v1/users', type: :request do
  let(:valid_attributes) do
    { username: 'jdoe', email: 'jdoe@email.com', password: 'pass123' }
  end

  let(:invalid_attributes) do
    { username: 'j', email: 'jdoe@email', password: 'pass' }
  end

  let(:valid_headers) do
    {}
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      user = User.create! valid_attributes
      token = JsonWebToken.encode(user_id: user.id)
      valid_headers[:Authorization] = token

      get api_v1_user_url(user), headers: valid_headers

      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(response.body).to include(user.id.to_s, user.username, user.email)
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new User' do
        expect do
          post api_v1_users_url, params: { user: valid_attributes }
        end.to change(User, :count).by(1)
      end

      it 'renders a JSON response with the newly created user' do
        post api_v1_users_url, params: { user: valid_attributes }

        expect(response).to have_http_status(:created)
        expect(response.body).to include(
          valid_attributes[:id].to_s,
          valid_attributes[:username],
          valid_attributes[:email]
        )
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new User' do
        expect do
          post api_v1_users_url, params: { user: invalid_attributes }
        end.to change(User, :count).by(0)
      end

      it 'renders a JSON response with errors for the new user' do
        post api_v1_users_url, params: { user: invalid_attributes }, headers: valid_headers

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH /update' do
    let(:user) { User.create! valid_attributes }

    before do
      token = JsonWebToken.encode(user_id: user.id)
      valid_headers[:Authorization] = token
    end

    context 'with valid parameters' do
      let(:new_attributes) do
        { username: 'jdoe', email: 'new@email.com', password: 'newpass' }
      end

      it 'updates the requested user' do
        patch api_v1_user_url(user), params: { user: new_attributes }, headers: valid_headers
        user.reload

        expect(response).to have_http_status(:ok)
      end

      it 'renders a JSON response with the user' do
        patch api_v1_user_url(user), params: { user: new_attributes }, headers: valid_headers

        expect(response.body).to include(new_attributes[:username], new_attributes[:email])
      end
    end

    context 'with invalid parameters' do
      it 'renders a JSON response with errors for the user' do
        patch api_v1_user_url(user), params: { user: invalid_attributes }, headers: valid_headers

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested user' do
      user = User.create! valid_attributes
      token = JsonWebToken.encode(user_id: user.id)
      valid_headers[:Authorization] = token

      expect do
        delete api_v1_user_url(user), headers: valid_headers
      end.to change(User, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
end
