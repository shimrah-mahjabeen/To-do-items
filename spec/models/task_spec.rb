# spec/models/task_spec.rb

require 'rails_helper'

RSpec.describe Task, type: :model do
  let!(:user) { create(:user) }

  it { should belong_to(:user) }
  it { should validate_presence_of(:title) }
  it { should validate_inclusion_of(:status).in_array(['pending', 'completed']) }

  describe 'scopes' do
    let!(:task_pending) { create(:task, user: user, status: :pending) }
    let!(:task_completed) { create(:task, user: user, status: :completed) }

    it 'returns tasks with pending status' do
      expect(Task.in_progress).to include(task_pending)
      expect(Task.in_progress).not_to include(task_completed)
    end

    it 'returns tasks with completed status' do
      expect(Task.completed).to include(task_completed)
      expect(Task.completed).not_to include(task_pending)
    end
  end
end
