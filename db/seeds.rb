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
first = recorder.recordabilities.create!
second = recorder.recordabilities.create!
third = recorder.recordabilities.create!
first.records.create!(option: ssr, count: 1)
first.records.create!(option: sr, count: 1)
second.records.create!(option: ssr, count: 1)
second.records.create!(option: sr, count: 3)
third.records.create!(option: sr, count: 1)
third.records.create!(option: ssr, count: 1)
third.records.create!(option: sr, count: 1)
wordful_recorder = user.recorders.create!(title: "a" * 255)
9.times do |n|
  name = "b" * 39
  wordful_recorder.options.create!(name: name << n)
end

49.times do |n|
  title = "pokemon#{n}"
  p_recorder = user.recorders.create!(title: title)
  49.times do |n|
    name = "option#{n}"
    p_recorder.options.create!(name: name)
    p_recorder.recordabilities.create.records.create!(option: p_recorder.options.first, count: 1)
  end
end
