module Types
  class TaskCountsType < Types::BaseObject
    field :total, Integer, null: false
    field :pending, Integer, null: false
    field :completed, Integer, null: false
  end
end
