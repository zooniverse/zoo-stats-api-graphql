#!/bin/bash

# Setup database manually
# docker-compose run --rm --entrypoint="bundle exec rake db:reset" zoo_stats
# Insert one of these below (input01 input02 input03 input04 input05 input06 input07 input08 input09 input10 input11 input12 input13 input14 input15)
# These match the following sizes (100K 200K 300K 400K 500K 750K 1M 2M 5M 10M 20M 50M 100M 500M 1B)
# docker exec zoo_stats_api_prototype_timescale_1 psql -U zoo_stats zoo_stats_development -c "COPY events FROM '/mnt/{INSERT HERE}.csv' DELIMITER ',' CSV HEADER;"
sizes_i=(100000 200000 300000 400000 500000 750000 1000000 2000000 5000000 10000000 20000000 50000000 100000000 500000000 1000000000)
i=12
# Change above to match index of database size
# copy start_list run to "{YOUR FILENAME HERE}.csv"
# type "{YOUR FILENAME HERE}.csv" below"
filename="test_output-22-yes_writes.csv"
output_file="./testing_results/${filename}"

path="/Users/samuelaroney/Data/"
script_path="./scripts/generate_testing_database/"
temp_file="./testing_results/temp"

repeats=$1
if [ "$2" = "no" ]
then
    writes="no"
else
    writes="yes"
fi

echo "|||Current database, appending to ${filename}|||"
echo "***Test setup***"
docker stop zoo_stats_api_prototype_timescale_1
docker start zoo_stats_api_prototype_timescale_1

echo "***Running database tests***"
database_size=${sizes_i[$i]}
if [ $writes = "yes" ]
then
    docker-compose run -e repeats=$repeats -e database_size=$database_size -e temp_file=$temp_file --rm --entrypoint="bundle exec foreman start" zoo_stats
    cat $temp_file >> $output_file
    rm $temp_file
else
    docker-compose run -e repeats=$repeats -e database_size=$database_size --rm --entrypoint="bin/rails runner scripts/generate_testing_database/run_database_tests.rb" zoo_stats >> $output_file
fi
echo "***Tests completed***"