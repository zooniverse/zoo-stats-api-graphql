require "benchmark"
require_relative "generate_events"

repeat_count = 100
test_user_id = 23450
database_size = ARGV[0]
times = []

4.times do
  time = Benchmark.measure do
    repeat_count.times do
      Event.where(user_id: test_user_id, event_type: "classification").group("project_id").count
      Event.where(user_id: test_user_id, event_type: "comment").group("project_id").count
    end
  end
  times.append(time.total)
  #generator_1 = Generator.new(100_000_000)
  #100.times { generator_1.generate_event }
end

puts "#{database_size},#{repeat_count},#{times[0]},#{times[1]},#{times[2]},#{times[3]}"
# output CSV layout
# database_size,repeat_count,cold,one,two,three

=begin
test_block = 

4.times do
  puts test_block
  time = Benchmark.measure do
    results = Event.where(event_id: [1, 2, 3, 4])
  end
  puts results
  puts time
end
=end

=begin
def timing_test(title)
  puts title
  ["cold", 1, 2, 3].each do |run|
    puts run
    time = Benchmark.measure { yield }
    puts time
  end
end

[
  "Multiple where":       { Event.where(event_id: [1, 2, 3, 4]) },
  "Ordered selection":    {     Event.limit(5).offset(30) },
  "Where and count":      { Event.where(user_id: 1).group("project_id").count }
]


=end