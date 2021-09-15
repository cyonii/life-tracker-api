require 'rails_helper'

RSpec.describe Activity, type: :model do
  subject { build(:activity) }

  describe 'Validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).case_insensitive }
  end

  describe 'Associations' do
    it { should have_many(:records) }
  end
end
