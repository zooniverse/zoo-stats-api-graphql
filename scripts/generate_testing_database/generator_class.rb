class Generator
  attr_accessor :event_id
  CLASSIFICATION_TO_COMMENT_RATIO = 50
  NIL_USER_TO_LOGGED_IN_RATIO = 1
  PROJECT_ID_MAX = 10_000
  USER_ID_MAX = 1_000_000

  WORKFLOW_ID_MAX = 10
  SUBJECT_ID_MAX = 1_000
  
  BOARD_ID_MAX = 100
  DISCUSSION_ID_MAX = 1_000
  FOCUS_ID_MAX = 10
  FOCUS_TYPES = ['chat', 'image analysis']

  def initialize(event_id)
    self.event_id = event_id
  end

  def generate_event
    user_id_options = [rand(1..USER_ID_MAX)]
    if rand(0..CLASSIFICATION_TO_COMMENT_RATIO) == 0
      # insert comment
      event_type = "comment"
      board_id = rand(1..BOARD_ID_MAX)
      discussion_id = rand(1..DISCUSSION_ID_MAX)
      focus_id = rand(1..FOCUS_ID_MAX)
      focus_type = FOCUS_TYPES[rand(0...FOCUS_TYPES.length)]
      section = "Random section here"
      body = "Random text here"
      url = "zooniverse.org/random/link/here"
      focus = "Random focus here"
      board = "Random board here"
      tags = '{"tag1", "tag2", "tag3"}'


      # nil for comment
      subject_ids = nil
      subject_urls = nil

    else
      # insert classification
      event_type = "classification"
      subject_ids = "{#{rand(1..SUBJECT_ID_MAX)}}"
      subject_urls = "{{'image/jpeg': 'https://image.jpg'}}"

      # nil for classification
      board_id = nil
      discussion_id = nil
      focus_id = nil
      focus_type = nil
      section = nil
      body = nil
      url = nil
      focus = nil
      board = nil
      tags = nil
    end

    Event.create(
      {
        'event_id':             self.event_id += 1,
        'event_type':           event_type,
        'event_source':         "Panoptes",
        'event_time':           Time.now,
        'event_created_at':     Time.now,
        'project_id':           rand(1..PROJECT_ID_MAX),
        'workflow_id':          rand(1..WORKFLOW_ID_MAX),
        'user_id':              user_id_options[rand(0..NIL_USER_TO_LOGGED_IN_RATIO)],
        'subject_ids':          subject_ids,
        'subject_urls':         subject_urls,
        'lang':                 "en",
        'user_agent':           nil,
        'user_name':            nil,
        'project_name':         nil,
        'board_id':             board_id,
        'discussion_id':        discussion_id,
        'focus_id':             focus_id,
        'focus_type':           focus_type,
        'section':              section,
        'body':                 body,
        'url':                  url,
        'focus':                focus,
        'board':                board,
        'tags':                 tags,
        'user_zooniverse_id':   nil,
        'zooniverse_id':        nil,
        'created_at':           Time.now,
        'updated_at':           Time.now,
      }
    )
  end
end
