require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user) }

  let(:valid_attributes) { { email: 'jdoe@email.com', password: 'pass123' } }

  subject { described_class.new(valid_attributes) }

  describe 'Validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without an email' do
      subject.email = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without a password' do
      subject.password = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid with a duplicate email' do
      subject.save
      duplicate_user = described_class.new(valid_attributes)
      expect(duplicate_user).to_not be_valid
    end

    it 'is not valid with an invalid email' do
      subject.email = 'jdoe@email'
      expect(subject).to_not be_valid
    end

    it { should validate_presence_of(:email) }

    it { should validate_uniqueness_of(:email).case_insensitive }

    it { should validate_length_of(:password).is_at_least(6) }
  end

  describe 'Associations' do
    it { should have_many(:records).dependent(:destroy) }
  end
end
