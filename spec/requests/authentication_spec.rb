require 'rails_helper'

RSpec.describe '/api/v1/auth', type: :request do
  describe 'POST /api/v1/auth' do
    context 'when user is NOT found' do
      before { post '/api/v1/auth', params: { email: 'rando@email.com', password: 'password' } }

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end

      it 'returns an invalid credentials message' do
        expect(response.body).to match(/Invalid credentials/)
      end
    end

    context 'when user is found' do
      let(:user) { create(:user) }

      before { post '/api/v1/auth', params: { email: user.email, password: user.password } }

      it 'successfully authenticates user' do
        expect(response).to have_http_status(200)
        expect(response).to have_http_status(:ok)
      end

      it 'returns a success message' do
        expect(response.body).to match(/Successfully authenticated/)
      end

      it 'returns the user' do
        expect(response.body).to match(/#{user.id}/)
        expect(response.body).to match(/#{user.username}/)
        expect(response.body).to match(/#{user.email}/)
      end

      it 'returns an auth_token' do
        expect(response.body).to match(/auth_token/)
      end
    end
  end
end
