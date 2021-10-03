require 'rails_helper'

RSpec.describe API::V1::AuthenticationController, type: :routing do
  describe 'routing' do
    it 'routes to #authenticate' do
      expect(post: '/api/v1/auth').to route_to('api/v1/authentication#authenticate')
    end
  end
end
