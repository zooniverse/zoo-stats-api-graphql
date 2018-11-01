require 'csv'

event_count_string = '1B'
event_count = 1_000_000_000
classification_to_comment_ratio = 50
event_id = 0
project_id_max = 10_000
workflow_id_max = 10
subject_id_max = 1_000
user_id_max = 1_000_000
nil_user_to_logged_in_ratio = 2

board_id_max = 100
discussion_id_max = 1_000
focus_id_max = 10
focus_types = ['chat', 'image analysis']


filename = 'input_count_' + event_count_string + '.csv'
CSV.open(filename, 'w') do |csv|
    csv << [
            'event_id',
            'event_type',
            'event_source',
            'event_time',
            'event_created_at',
            'project_id',
            'workflow_id',
            'user_id',
            'subject_ids',
            'subject_urls',
            'lang',
            'user_agent',
            'user_name',
            'project_name',
            'board_id',
            'discussion_id',
            'focus_id',
            'focus_type',
            'section',
            'body',
            'url',
            'focus',
            'board',
            'tags',
            'user_zooniverse_id',
            'zooniverse_id',
            'created_at',
            'updated_at'
    ]

    event_count.times do
        user_id_options = [rand(1..user_id_max)]
        if rand(0..classification_to_comment_ratio) == 0
            # insert comment
            event_type = "comment"
            board_id = rand(1..board_id_max)
            discussion_id = rand(1..discussion_id_max)
            focus_id = rand(1..focus_id_max)
            focus_type = focus_types[rand(0...focus_types.length)]
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
            subject_ids = "{#{rand(1..subject_id_max)}}"
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
        csv << [
                event_id += 1,                                          # event_id
                event_type,                                             # event_type
                "Panoptes",                                             # event_source
                Time.now,                                               # event_time
                Time.now,                                               # event_created_at
                rand(1..project_id_max),                                # project_id
                rand(1..workflow_id_max),                               # workflow_id
                user_id_options[rand(0..nil_user_to_logged_in_ratio)],  # user_id
                subject_ids,                                            # subject_ids
                subject_urls,                                           # subject_urls
                "en",                                                   # lang
                nil,                                                    # user_agent
                nil,                                                    # user_name
                nil,                                                    # project_name
                board_id,                                               # board_id
                discussion_id,                                          # discussion_id
                focus_id,                                               # focus_id
                focus_type,                                             # focus_type
                section,                                                # section
                body,                                                   # body
                url,                                                    # url
                focus,                                                  # focus
                board,                                                  # board
                tags,                                                   # tags
                nil,                                                    # user_zooniverse_id
                nil,                                                    # zooniverse_id
                Time.now,                                               # created_at
                Time.now,                                               # updated_at
        ]
    end
end
