module Searchers
  class Bucket
    def self.search(query_filters)
      time_bucket = query_filters.delete(:interval)
      window = query_filters.delete(:window)
      Event.select(
          "time_bucket('#{time_bucket}', event_time) AS period, count(*)"
        )
        .group("period")
        .where(**query_filters)
        .where("event_time >= NOW() - INTERVAL ?", window)
    end
  end
end