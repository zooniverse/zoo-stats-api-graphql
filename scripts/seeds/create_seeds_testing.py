# Classification.create({
#  "classification_id": 124958854,
#  "project_id": 593,
#  "workflow_id": 338,
#  "subject_ids": "['26127879']",
#  "subject_urls": "United States"
# })

import csv

f = csv.reader(open('maybe_more.csv', 'r'))
g = open('seed_raw_testing.txt', 'w') #, newline='')

user_n = 0
user_count = 0
time_count = 0
for raw_line in f:
    line = []
    if user_count == 100:
        user_n += 1
        user_count = 0
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
        ', "event_time": ', 'time_now + ' + str(time_count + 1) + '.seconds',
        ', "event_created_at": ', 'time_now + ' + str(time_count + 2) + '.seconds',
        ', "project_id": ', line[1],
        ', "workflow_id": ', line[2],
        ', "user_id": ', str(user_n),
        ', "subject_ids": ', '"' + line[4].replace("'", "\\'") + '"',
        ', "subject_urls": ', '"' + line[5].replace("'", "\\'") + '"',
        ', "lang": ', '"en"',
        ', "user_agent": ', '"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/69.0.3497.100 Safari/537.36"',
        ', "user_name": ', '"User' + str(user_n) + '"',
        ', "project_name": ', '"Project' + str(line[1]) + '"',
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
        ', "zooniverse_id": ', line[2],
        '})\n'
    ]

    write_line = ''
    for item in insert_line:
        write_line += item

    g.write(write_line)
    user_count += 1
    time_count += 1

g.close()