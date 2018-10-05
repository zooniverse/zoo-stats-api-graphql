# Classification.create({
#  "classification_id": 124958854,
#  "project_id": 593,
#  "workflow_id": 338,
#  "subject_ids": "['26127879']",
#  "subject_urls": "United States"
# })

import csv

f = csv.reader(open('input_data.csv', 'r'))
g = open('seed_raw.txt', 'w') #, newline='')


for raw_line in f:
    line = []
    for item in raw_line:
        if item != '':
            line.append(item)
        else:
            line.append('nil')

    insert_line = [
        'Event.create({',
        '"event_id": ', line[0],
        ', "event_type": ', '"classification"',
        ', "event_source": ', '"panoptes"',
        ', "event_time": ', 'Time.now',
        ', "event_created_at": ', 'Time.now + 10.seconds',
        ', "project_id": ', line[1],
        ', "workflow_id": ', line[2],
        ', "user_id": ', line[3],
        ', "subject_ids": ', '"', line[4], '"',
        ', "subject_urls": ', '"[{\'image/jpeg\': \'https://image.jpg\'}]"',
        ', "lang": ', '"en"',
        ', "user_agent": ', '"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/69.0.3497.100 Safari/537.36"',
        ', "user_name": ', 'nil',
        ', "project_name": ', 'nil',
        ', "board_id": ', 'nil',
        ', "discussion_id": ', 'nil',
        ', "focus_id": ', 'nil',
        ', "focus_type": ', 'nil',
        ', "section": ', 'nil',
        ', "body": ', 'nil',
        ', "url": ', 'nil',
        ', "focus": ', 'nil',
        ', "board": ', 'nil',
        ', "tags": ', 'nil',
        ', "user_zooniverse_id": ', line[3],
        ', "zooniverse_id": ', 'nil',
        '})\n'
    ]

    write_line = ''
    for item in insert_line:
        write_line += item

    g.write(write_line)

g.close()