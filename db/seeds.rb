user = User.create!(email: "hoge@example.com",
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

recorder = user.recorders.create!(title: "hoge")
ssr = recorder.options.create!(name: "ssr")
sr = recorder.options.create!(name: "sr")
recorder.options.create!(name: "r")
recorder.records.create!(option: ssr)
recorder.records.create!(option: sr)
recorder.records.create!(option: ssr)
recorder.records.create!(option: sr)
recorder.records.create!(option: sr)
recorder.records.create!(option: ssr)
recorder.records.create!(option: sr)
wordful_recorder = user.recorders.create!(title: "a" * 255)
9.times do |n|
  name = "b" * 40
  wordful_recorder.options.create!(name: name)
end

49.times do |n|
  title = "pokemon#{n}"
  p_recorder = user.recorders.create!(title: title)
  49.times do |n|
    name = Faker::Pokemon.name
    p_recorder.options.create!(name: name)
    p_recorder.options.first.records.create!(recorder: p_recorder)
  end
end
