require "benchmark"
require_relative "generate_events"

repeat_count = 100
database_size = ARGV[0]
times = []

# Query variables
test_user_id = nil
time_value = 1
time_units = 'seconds'

4.times do
  time = Benchmark.measure do
    repeat_count.times do
      time_bucket = Event.select("time_bucket('#{time_value} #{time_units}', event_time) AS bucket, count(*), project_id").group("bucket")
      time_bucket.where(user_id: test_user_id, event_type: "classification").group("project_id")
      time_bucket.where(user_id: test_user_id, event_type: "comment").group("project_id")
    end
  end
  times.append(time.total)
  #generator_1 = Generator.new(100_000_000)
  #100.times { generator_1.generate_event }
end

puts "#{database_size},#{repeat_count},#{times[0]},#{times[1]},#{times[2]},#{times[3]}"
# output CSV layout
# database_size,repeat_count,cold,one,two,three



## ActiveRecord queries

# select (add SQL code in "")
# Time bucket:          Event.select("time_bucket('1 seconds', event_time) AS bucket, count(*)").group("bucket")

# where (search for matching records)
# Specific where:       Event.where(user_id: 1)
# Between where:        Event.where(user_id: 1..1000)
# In where:             Event.where(event_id: [1, 3, 4, 11])

# other methods
# Bounded selection:    Event.limit(5).offset(30)
# Full count:           Event.all.count
# Group by:             Event.all.group("project_id")
# Attributes:           Event.all.first.attributes.to_yaml
