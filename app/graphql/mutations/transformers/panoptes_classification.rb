module Transformers
  class PanoptesClassification
    attr_accessor :payload

    def initialize(payload)
      @payload = payload
    end

    def transform
      {
        event_id:        id,
        event_type:      type,
        event_source:    source,
        event_time:      time,
        project_id:      project,
        workflow_id:     workflow,
        user_id:         user,
        data:            remaining_data,
        session_time:    session_time
      }
    end

    private
    def id
      payload.dig("data", "id")
    end

    def type
      payload.dig("type")
    end

    def source
      payload.dig("source")
    end

    def time
      DateTime.parse(payload.dig("data", "metadata", "finished_at"))
    end

    def project
      payload.dig("data", "links", "project")
    end

    def workflow
      payload.dig("data", "links", "workflow")
    end

    def user
      payload.dig("data", "links", "user")
    end

    def remaining_data
      # TODO: do we want to store the metadata or the diff of the data minus what we have?
      # attributes.data - attributes already in payload
      payload["data"]
    end

    def session_time
      metadata = payload.dig("data","metadata")
      started_at = metadata["started_at"]
      finished_at = metadata["finished_at"]
      diff = DateTime.parse(finished_at).to_i - DateTime.parse(started_at).to_i
      diff.to_f
    end
  end
end