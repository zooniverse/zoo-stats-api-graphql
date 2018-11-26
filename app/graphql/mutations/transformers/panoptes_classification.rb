require_relative '../geo'

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
        event_time:      finished_at,
        project_id:      project,
        workflow_id:     workflow,
        user_id:         user,
        data:            remaining_data,
        session_time:    session_time,
        geo:             geo
      }
    end

    private
    def remaining_data
      {
        subject_id:              subject_id,
        created_at:              created_at,
        updated_at:              updated_at,
        workflow_version:        workflow_version,
        gold_standard:           gold_standard,
        expert_classifier:       expert_classifier,
        metadata_started_at:     started_at,
        metadata_finished_at:    finished_at,
        metadata_session:        session,
        metadata_utc_offset:     utc_offset,
        metadata_user_language:  user_language
      }
    end

    def type
      payload.dig("type")
    end

    def source
      payload.dig("source")
    end

    def id
      payload.dig("data", "id")
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

    def subject_id
      if subject_ids = payload.dig("data", "links", "subjects")
        subject_ids.first
      end
    end

    def created_at
      if created_at = payload.dig("data", "created_at")
        DateTime.parse(created_at)
      end
    end

    def updated_at
      if updated_at = payload.dig("data", "updated_at")
        DateTime.parse(updated_at)
      end
    end

    def workflow_version
      payload.dig("data", "workflow_version")
    end

    def gold_standard
      payload.dig("data", "gold_standard")
    end

    def expert_classifier
      payload.dig("data", "expert_classifier")
    end

    def started_at
      return @started_at if defined? @started_at
      if started_at = payload.dig("data", "metadata", "started_at")
        @started_at = DateTime.parse(started_at)
      end
    end

    def finished_at
      return @finished_at if defined? @finished_at
      if finished_at = payload.dig("data", "metadata", "finished_at")
        @finished_at = DateTime.parse(finished_at)
      end
    end

    def session
      payload.dig("data", "metadata", "session")
    end

    def utc_offset
      payload.dig("data", "metadata", "utc_offset")
    end

    def user_language
      payload.dig("data", "metadata", "user_language")
    end

    def session_time
      diff = finished_at.to_i - started_at.to_i
      diff.to_f
    end

    def geo
      Geo.locate(payload.dig("data", "user_ip"))
    end
  end
end