User.create!(email: "hoge@example.com",
             password: "hogehoge",
             password_confirmation: "hogehoge")
User.create!(email: "Lenneth@example.com",
             password: "valkyrie",
             password_confirmation: "valkyrie",
             admin: true)

49.times do |n|
  email = "example-#{n+1}@example.com"
  password = "password"
  User.create!(email: email,
               password: password,
               password_confirmation: password)
end

recorder = Recorder.create!(title: "hoge")
recorder.options.create!(name: "ssr")
recorder.options.create!(name: "sr")
recorder.options.create!(name: "r")
recorder.records.create!(data: "ssr")
recorder.records.create!(data: "sr")
recorder.records.create!(data: "r")
recorder.records.create!(data: "sr")
recorder.records.create!(data: "r")

49.times do |n|
  title = Faker::Pokemon.name
  Recorder.create!(title: title)
end
