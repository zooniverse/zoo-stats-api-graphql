# frozen_string_literal: true

class EventsSerializer
  attr_reader :events

  MAX_LIMIT = ENV.fetch('EVENTS_MAX_LIMIT', 500).to_i

  def initialize(events_scope)
    @events = events_scope
  end

  def as_json(options)
    serializer_options = options[:serializer_options]
    # apply the limit from param or defaults
    limit = clamped_limit(serializer_options[:limit])
    # apply the period order from param or default to :asc
    order = serializer_options[:order] || :asc
    events_scope = events.order(period: order).limit(limit)

    # return a formatted hash that encodes to JSON
    {
      events_over_time: {
        buckets: events_scope
      }
    }
  end

  private

  def clamped_limit(limit)
    limit ||= 100 # default to 100 events if not set
    limit.to_i.clamp(0, MAX_LIMIT) # keep the limit sane
  end
end
