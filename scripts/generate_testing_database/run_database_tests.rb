require "benchmark"

time = Benchmark.measure do
  results = Event.where(event_id: [1, 2, 3, 4])
end

puts time