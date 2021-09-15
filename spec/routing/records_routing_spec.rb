require 'rails_helper'

RSpec.describe API::V1::RecordsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: 'api/v1/activities/1/records').to route_to('api/v1/records#index', activity_id: '1')
    end

    it 'routes to #show' do
      expect(get: 'api/v1/activities/1/records/1').to route_to('api/v1/records#show', id: '1', activity_id: '1')
    end

    it 'routes to #create' do
      expect(post: 'api/v1/activities/1/records').to route_to('api/v1/records#create', activity_id: '1')
    end

    it 'routes to #update via PUT' do
      expect(put: 'api/v1/activities/1/records/1').to route_to('api/v1/records#update', id: '1', activity_id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: 'api/v1/activities/1/records/1').to route_to('api/v1/records#update', id: '1', activity_id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: 'api/v1/activities/1/records/1').to route_to('api/v1/records#destroy', id: '1', activity_id: '1')
    end
  end
end
