require 'rails_helper'

RSpec.describe '/records', type: :request do
  let(:user) { create(:user) }
  let(:activity) { create(:activity) }

  let(:valid_attributes) do
    { duration: '17', satisfaction: '1', date: Date.new, activity_id: activity.id }
  end

  let(:invalid_attributes) do
    { duration: '1445', satisfaction: 32, activity_id: activity.id }
  end

  let(:valid_headers) do
    { Authorization: "Bearer #{JsonWebToken.encode(user_id: user.id)}" }
  end

  describe 'GET /index' do
    it 'renders a successful response' do
      create(:record)
      get api_v1_activity_records_url(activity_id: activity.id), headers: valid_headers

      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      record = create(:record)

      get api_v1_activity_record_url(record, activity_id: record.activity.id), headers: valid_headers
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Record' do
        expect do
          post api_v1_activity_records_url(activity_id: activity.id),
               params: { record: valid_attributes }, headers: valid_headers
        end.to change(Record, :count).by(1)
      end

      it 'renders a JSON response with the new record' do
        post api_v1_activity_records_url(activity_id: activity.id),
             params: { record: valid_attributes }, headers: valid_headers
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Record' do
        expect do
          post api_v1_activity_records_url(activity_id: activity.id),
               params: { record: invalid_attributes }
        end.to change(Record, :count).by(0)
      end

      it 'renders a JSON response with errors for the new record' do
        post api_v1_activity_records_url(activity_id: activity.id),
             params: { record: invalid_attributes }, headers: valid_headers
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        { duration: '17', satisfaction: '1', date: Date.new }
      end

      it 'updates the requested record' do
        record = create(:record)
        patch api_v1_activity_record_url(record, activity_id: activity.id),
              params: { record: new_attributes }, headers: valid_headers
        record.reload

        expect(record.duration).to eq(Float(new_attributes[:duration]))
        expect(record.satisfaction).to eq(Integer(new_attributes[:satisfaction]))
        expect(record.date).to eq(new_attributes[:date])
      end

      it 'renders a JSON response with the record' do
        record = create(:record)
        patch api_v1_activity_record_url(record, activity_id: activity.id),
              params: { record: new_attributes }, headers: valid_headers
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid parameters' do
      it 'renders a JSON response with errors for the record' do
        record = create(:record)
        patch api_v1_activity_record_url(record, activity_id: activity.id),
              params: { record: invalid_attributes }, headers: valid_headers
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested record' do
      record = create(:record)
      expect do
        delete api_v1_activity_record_url(record, activity_id: activity.id), headers: valid_headers
      end.to change(Record, :count).by(-1)
    end
  end
end
