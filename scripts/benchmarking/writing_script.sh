#!/bin/bash

echo "Script starting"


file_array=(input01.csv input02.csv input03.csv input04.csv input05.csv input06.csv input07.csv input08.csv input09.csv input10.csv input11.csv input12.csv input13.csv input14.csv input15.csv)
start_array=(2 100002 200002 300002 400002 500002 750002 1000002 2000002 5000002 10000002 20000002 50000002 100000002 500000002)
end_array=(100001 200001 300001 400001 500001 750001 1000001 2000001 5000001 10000001 20000001 50000001 100000001 500000001 945520126)

for i in {0..14}; do
    head -n 1 generated_data_1B.csv > ${file_array[$i]}
    head -n ${end_array[$i]} generated_data_1B.csv | tail -n +${start_array[$i]} >> ${file_array[$i]}
    echo "${file_array[$i]} finished"
done

# input01.csv, cummulative count = 100K, size = 100K,  start: 2              , end: 100,001
# input02.csv, cummulative count = 200K, size = 100K,  start: 100,002        , end: 200,001
# input03.csv, cummulative count = 300K, size = 100K,  start: 200,002        , end: 300,001
# input04.csv, cummulative count = 400K, size = 100K,  start: 300,002        , end: 400,001
# input05.csv, cummulative count = 500K, size = 100K,  start: 400,002        , end: 500,001
# input06.csv, cummulative count = 750K, size = 250K,  start: 500,002        , end: 750,001
# input07.csv, cummulative count = 1M,   size = 250K,  start: 750,002        , end: 1,000,001
# input08.csv, cummulative count = 2M,   size = 1M,    start: 1,000,002      , end: 2,000,001
# input09.csv, cummulative count = 5M,   size = 3M,    start: 2,000,002      , end: 5,000,001
# input10.csv, cummulative count = 10M,  size = 5M,    start: 5,000,002      , end: 10,000,001
# input11.csv, cummulative count = 20M,  size = 10M,   start: 10,000,002     , end: 20,000,001
# input12.csv, cummulative count = 50M,  size = 30M,   start: 20,000,002     , end: 50,000,001
# input13.csv, cummulative count = 100M, size = 50M,   start: 50,000,002     , end: 100,000,001
# input14.csv, cummulative count = 500M, size = 400M,  start: 100,000,002    , end: 500,000,001
# input15.csv, cummulative count = ~1B,  size = ~445M, start: 500,000,002    , end: 945,520,126





