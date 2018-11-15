class Generator
  attr_accessor :event_id
  CLASSIFICATION_TO_COMMENT_RATIO = 50
  NIL_USER_TO_LOGGED_IN_RATIO = 1
  PROJECT_ID_MAX = 10_000
  USER_ID_MAX = 1_000_000
  WORKFLOW_ID_MAX = 10
  SESSION_TIME_MAX = 600.0

  def initialize(event_id)
    self.event_id = event_id.to_i
  end

  def generate_event
    user_id_options = [rand(1..USER_ID_MAX)]
    if rand(0..CLASSIFICATION_TO_COMMENT_RATIO) == 0
      # insert comment
      event_type = "comment"
      # nil for comment
      session_time = nil
    else
      # insert classification
      event_type = "classification"
      session_time = rand(1..SESSION_TIME_MAX)
    end

    time_stamp = Time.zone.parse('2018-09-23 05:45:09') + self.event_id.hours - rand(1..10).hours

    Event.create(
      {
        'event_id':             self.event_id += 1,
        'event_type':           event_type,
        'event_source':         "Panoptes",
        'event_time':           time_stamp,
        'event_created_at':     time_stamp,
        'project_id':           rand(1..PROJECT_ID_MAX),
        'workflow_id':          rand(1..WORKFLOW_ID_MAX),
        'user_id':              user_id_options[rand(0..NIL_USER_TO_LOGGED_IN_RATIO)],
        'created_at':           time_stamp,
        'updated_at':           time_stamp,
        'data':                 "{}",
        'session_time':         session_time,
      }
    )
  end
end
