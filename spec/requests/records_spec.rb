require 'rails_helper'

RSpec.describe '/records', type: :request do
  # rubocop:disable Metrics/BlockLength
  context 'When user is the record owner' do
    describe 'GET /index' do
      it 'renders a successful response' do
        record = create(:record)
        get api_v1_records_url(activity_id: record.activity_id),
            headers: { Authorization: "Bearer #{JsonWebToken.encode(user_id: record.user_id)}" }

        expect(response).to have_http_status(:success)
        expect(response).to be_successful
      end
    end

    describe 'GET /show' do
      it 'renders a successful response' do
        record = create(:record)
        get api_v1_record_url(record, activity_id: record.activity.id),
            headers: { Authorization: "Bearer #{JsonWebToken.encode(user_id: record.user_id)}" }

        expect(response).to be_successful
      end
    end

    describe 'POST /create' do
      context 'with valid parameters' do
        let(:user) { create(:user) }
        let(:activity) { create(:activity) }
        let(:valid_attributes) { { duration: '17', satisfaction: '1', date: Date.new, activity_id: activity.id } }

        it 'creates a new Record' do
          expect do
            post api_v1_records_url(activity_id: activity.id),
                 params: { record: valid_attributes },
                 headers: { Authorization: "Bearer #{JsonWebToken.encode(user_id: user.id)}" }
          end.to change(Record, :count).by(1)
        end

        it 'renders a JSON response with the new record' do
          post api_v1_records_url(activity_id: activity.id),
               params: { record: valid_attributes },
               headers: { Authorization: "Bearer #{JsonWebToken.encode(user_id: user.id)}" }

          expect(response).to have_http_status(:created)
        end
      end

      context 'with invalid parameters' do
        let(:activity) { create(:activity) }
        let(:user) { create(:user) }
        let(:invalid_attributes) { { duration: '1445', satisfaction: 32, activity_id: 7 } }

        it 'does not create a new Record' do
          expect do
            post api_v1_records_url(activity_id: activity.id),
                 params: { record: invalid_attributes },
                 headers: { Authorization: "Bearer #{JsonWebToken.encode(user_id: user.id)}" }
          end.to change(Record, :count).by(0)
        end

        it 'renders a JSON response with errors for the new record' do
          post api_v1_records_url(activity_id: activity.id),
               params: { record: invalid_attributes },
               headers: { Authorization: "Bearer #{JsonWebToken.encode(user_id: user.id)}" }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe 'PATCH /update' do
      context 'with valid parameters' do
        let(:record) { create(:record) }
        new_attributes = { duration: '17', satisfaction: '1', date: Date.new }

        it 'updates the requested record' do
          patch api_v1_record_url(record, activity_id: record.activity_id),
                params: { record: new_attributes },
                headers: { Authorization: "Bearer #{JsonWebToken.encode(user_id: record.user_id)}" }
          record.reload

          expect(record.duration).to eq(Float(new_attributes[:duration]))
          expect(record.satisfaction).to eq(Integer(new_attributes[:satisfaction]))
          expect(record.date).to eq(new_attributes[:date])
        end

        it 'renders a JSON response with the record' do
          patch api_v1_record_url(record, activity_id: record.activity_id),
                params: { record: new_attributes },
                headers: { Authorization: "Bearer #{JsonWebToken.encode(user_id: record.user_id)}" }
          expect(response).to have_http_status(:ok)
        end
      end

      context 'with invalid parameters' do
        it 'renders a JSON response with errors for the record' do
          record = create(:record)
          patch api_v1_record_url(record, activity_id: record.activity_id),
                params: { record: { duration: '1445' } },
                headers: { Authorization: "Bearer #{JsonWebToken.encode(user_id: record.user_id)}" }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe 'DELETE /destroy' do
      it 'destroys the requested record' do
        record = create(:record)

        expect do
          delete api_v1_record_url(record, activity_id: record.activity_id),
                 headers: { Authorization: "Bearer #{JsonWebToken.encode(user_id: record.user_id)}" }
        end.to change(Record, :count).by(-1)
      end
    end
  end

  # rubocop:enable Metrics/BlockLength

  context 'When user is NOT record owner' do
    # All requests to /records should return a 403
    it "doesn't let access to activity record list to another user" do
      user = create(:user)
      activity = create(:activity)

      2.times { create(:record, activity: activity) }

      get api_v1_records_url(activity_id: activity.id),
          headers: { Authorization: "Bearer #{JsonWebToken.encode(user_id: user.id)}" }
      expect(response).to have_http_status(:forbidden)
    end

    it "it doesn't let access to a single activity record to another user" do
      user = create(:user)
      activity = create(:activity)
      record = create(:record, activity: activity)

      get api_v1_record_url(record, activity_id: activity.id),
          headers: { Authorization: "Bearer #{JsonWebToken.encode(user_id: user.id)}" }
      expect(response).to have_http_status(:forbidden)
    end
  end
end
# rubocop disable Metrics/BlockLength
