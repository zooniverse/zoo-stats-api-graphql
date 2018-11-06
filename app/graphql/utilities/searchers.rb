module Searchers
  class Complete
    def search(kwargs)
      Event.where(**kwargs)
    end
  end

  class Bucket
    def search(kwargs)
      time_bucket = kwargs.delete(:time_bucket)
      Event.select("time_bucket('#{time_bucket}', event_time) AS bucket, count(*)").group("bucket").where(**kwargs)
    end
  end
end