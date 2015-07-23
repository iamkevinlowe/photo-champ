require 'faker'

# Create Users
10.times do
  user = User.new(
    name: Faker::Name.name,
    email: Faker::Internet.email,
    password: Faker::Lorem.characters(10)
    )
  user.skip_confirmation!
  user.save!
end
user = User.new(
  name: 'User',
  email: 'user@example.com',
  password: 'helloworld'
  )
user.skip_confirmation!
user.save!
user = User.new(
  name: 'User2',
  email: 'user2@example.com',
  password: 'helloworld'
  )
user.skip_confirmation!
user.save!
users = User.all

# Create Categories
10.times do
  category = Category.new(
    name: Faker::Lorem.word,
    )
  category.save!
end
categories = Category.all

# Create Photos
50.times do
  photo = Photo.new(
    url: 'http://placehold.it/360x240',
    win: rand(50),
    loss: rand(50),
    tie: rand(10),
    user: users.sample,
    category: categories.sample
    )
  photo.save!
end
photos = Photo.all

# Create Challenges
10.times do
  n = categories.sample.id
  challenge = Challenge.new(
    challenger: photos.select{|photo| photo.category_id == n}.sample,
    challenged: photos.select{|photo| photo.category_id == n}.sample,
    length: (rand(2)+1)*6
    )
  challenge.save!
end
challenges = Challenge.all

puts "#{users.count} Users created."
puts "#{categories.count} Categories created."
puts "#{photos.count} Photos created."
puts "#{challenges.count} Challenges created."