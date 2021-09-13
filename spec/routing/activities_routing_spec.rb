require 'rails_helper'

RSpec.describe Api::V1::ActivitiesController, type: :routing do
  let(:activity) { create(:activity) }
  let(:base_url) { 'api/v1/activities' }

  describe 'routing' do
    it 'routes to #index' do
      expect(get: base_url).to route_to('api/v1/activities#index')
    end

    it 'routes to #show' do
      expect(get: "#{base_url}/#{activity.id}").to route_to(
        'api/v1/activities#show',
        id: activity.id.to_s
      )
    end
  end
end
