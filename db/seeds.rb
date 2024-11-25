require 'faker'

puts "Seeding data..."

User.destroy_all
Task.destroy_all

puts "Creating users..."
users = []
5.times do
  users << User.create!(
    email: Faker::Internet.unique.email,
    password: 'password',
    password_confirmation: 'password',
    name: Faker::Name.name 
  )
end

puts "Created #{users.count} users."

puts "Creating tasks for users..."
users.each do |user|
  rand(5..10).times do
    user.tasks.create!(
      title: Faker::Lorem.sentence(word_count: 3),
      status: Task.statuses.keys.sample,
      created_at: Faker::Time.between(from: 30.days.ago, to: Time.now),
      due_on: Faker::Time.between(from: Time.now, to: 60.days.from_now)
    )
  end
end

puts "Seeding complete. Created #{Task.count} tasks across #{User.count} users."
