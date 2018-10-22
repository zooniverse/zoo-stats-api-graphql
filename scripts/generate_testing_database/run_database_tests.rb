require "benchmark"
require_relative "generate_events"

puts "test01"
puts "test02"
puts "test03"
events_generator = Utilities.new
events_generator.event_id = 100_000
events_generator.generate_event

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