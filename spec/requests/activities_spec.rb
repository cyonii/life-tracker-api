require 'rails_helper'

RSpec.describe '/activities', type: :request do
  let(:user) { create(:user) }

  let(:valid_attributes) { { name: 'Activity' } }

  context 'when is authenticated' do
    let(:valid_headers) { { 'Authorization' => "Bearer #{JsonWebToken.encode(user_id: user.id)}" } }

    describe 'GET /index' do
      it 'renders a successful response' do
        Activity.create! valid_attributes
        get api_v1_activities_url(user_id: user.id), headers: valid_headers
        expect(response).to be_successful
      end
    end

    describe 'GET /show' do
      it 'renders a successful response' do
        activity = Activity.create! valid_attributes
        get api_v1_activity_url(activity, user_id: user.id), headers: valid_headers
        expect(response).to be_successful
      end
    end
  end

  context 'when the user is not authenticated' do
    describe 'GET /index' do
      it 'returns status code 401' do
        get api_v1_activities_url(user_id: user.id)
        expect(response).to have_http_status(401)
      end
    end

    describe 'GET /show' do
      it 'returns status code 401' do
        activity = Activity.create! valid_attributes
        get api_v1_activity_url(activity, user_id: user.id)
        expect(response).to have_http_status(401)
      end
    end
  end
end
