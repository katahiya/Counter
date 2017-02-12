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
