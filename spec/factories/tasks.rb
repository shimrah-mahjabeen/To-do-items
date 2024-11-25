FactoryBot.define do
  factory :task do
    title { "Sample Task" }
    description { "This is a test task." }
    due_on { Date.today }
    status { :in_progress } 
    user
  end
end
