class Task < ApplicationRecord
  belongs_to :user
  
  enum status: { pending: "pending", completed: "completed", cancelled: "cancelled" }

  validates :title, presence: true
  validates :status, inclusion: { in: statuses.keys }

  scope :in_progress, -> { where(status:  'pending') }
  scope :completed, -> { where(status: 'completed') }

  def self.ransackable_attributes(auth_object = nil)
      %w[created_at description id status title updated_at]
  end
end  