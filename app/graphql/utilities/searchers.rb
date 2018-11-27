module Searchers
  class Bucket
    def search(kwargs)
      time_bucket = kwargs.delete(:interval)
      Event.select("time_bucket('#{time_bucket}', event_time) AS period, count(*)").group("period").where(**kwargs)
    end
  end
end