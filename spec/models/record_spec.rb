require 'rails_helper'

RSpec.describe Record, type: :model do
  subject { build(:record) }

  describe 'Validations' do
    it { should validate_presence_of(:duration) }
    it { should validate_presence_of(:satisfaction) }
    it { should validate_presence_of(:date) }
    it {
      should validate_uniqueness_of(:date)
        .scoped_to(%i[user_id activity_id])
        .ignoring_case_sensitivity
        .with_message('record for this activity on this date already exists')
    }
  end

  describe 'Associations' do
    it { should belong_to :user }
    it { should belong_to :activity }
  end
end
