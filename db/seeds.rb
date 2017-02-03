recorder = Recorder.create!(title: "hoge")
recorder.options.create!(name: "ssr")
recorder.options.create!(name: "sr")
recorder.options.create!(name: "r")

49.times do |n|
  title = Faker::Name.name
  Recorder.create!(title: title)
end
