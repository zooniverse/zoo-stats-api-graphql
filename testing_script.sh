#!/bin/bash

file_array=(input01 input02 input03 input04 input05 input06 input07 input08 input09 input10 input11 input12 input13 input14 input15)
sizes=(100K 200K 300K 400K 500K 750K 1M 2M 5M 10M 20M 50M 100M 500M 1B)
sizes_i=(100000 200000 300000 400000 500000 750000 1000000 2000000 5000000 10000000 20000000 50000000 100000000 500000000 1000000000)
path="/Users/samuelaroney/Data/"
script_path="./scripts/generate_testing_database/"
repeats=1000
writes="yes"
output_file="./testing_results/test_output-${repeats}-${writes}_writes.csv"

# List of inputs to use
quick_list=(0 1)
start_list=(0 1 2 9)
extra_list=(0 1 2 9 10 11 14)
all_list=(0 1 2 3 4 5 6 7 8 9 10 11 12 13 14)

echo "***Script setup***"
echo "database_size,time,cold" > $output_file

for i in ${quick_list[@]}
do
    echo "|||Database size ${sizes[$i]}|||"
    echo "***Reset database***"
    docker-compose run --rm --entrypoint="bundle exec rake db:reset" zoo_stats
    echo "***Importing data***"

    # Import using mounted folder (see docker-compose)
    docker exec zoo_stats_api_prototype_timescale_1 psql -U zoo_stats zoo_stats_development -c "COPY events FROM '/mnt/${file_array[$i]}.csv' DELIMITER ',' CSV HEADER;"

    echo "***Test setup***"
    docker stop zoo_stats_api_prototype_timescale_1
    docker start zoo_stats_api_prototype_timescale_1

    echo "***Running database tests***"
    database_size=${sizes_i[$i]}
    if [ $writes = "yes" ]
    then
        docker-compose run -e repeats=$repeats -e database_size=$database_size --rm --entrypoint="bundle exec foreman start" zoo_stats
        # cat ./testing_results/temp >> $output_file
        # rm ./testing_results/temp
    else
        docker-compose run -e repeats=$repeats -e database_size=$database_size --rm --entrypoint="bin/rails runner scripts/generate_testing_database/run_database_tests.rb" zoo_stats >> $output_file
    fi
    echo "***Tests completed***"
done