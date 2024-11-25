# spec/models/user_spec.rb

require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }

  it { should allow_value('test@example.com').for(:email) }
  it { should_not allow_value('invalid-email').for(:email) }

  it { should have_many(:tasks).dependent(:destroy) }

  describe 'Devise authentication' do
    let!(:user) { create(:user) }

    it 'authenticates with valid credentials' do
      expect(User.find_for_database_authentication(email: user.email)).to eq(user)
    end

    it 'does not authenticate with invalid credentials' do
      invalid_user = build(:user, email: 'wrong@example.com')
      expect(User.find_for_database_authentication(email: invalid_user.email)).to be_nil
    end
  end

  describe 'dependent destroy' do
    let!(:user) { create(:user) }
    let!(:task) { create(:task, user: user) }

    it 'deletes associated tasks when user is deleted' do
      expect { user.destroy }.to change { Task.count }.by(-1)
    end
  end
end
