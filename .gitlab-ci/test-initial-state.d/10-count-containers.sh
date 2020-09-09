#!/bin/bash

#
# Test that the number of containers matches the expected number.
# @param $1 - The expected number of containers.
#
has_expected_num() {
  local _num_containers=$(docker container ls --format '{{json .Names}}' | \
    wc -l) 
  [ "$_num_containers" = "${1:-0}" ]
}

run_test() {
  _sleep_time_secs=60
  _wait_count=5
  _count=0
  _expected_num_containers=4

  echo "Test that there are $_expected_num_containers containers..."

  while [ $_count -lt $_wait_count ]; do
    if has_expected_num "$_expected_num_containers"; then
      echo "Test succeeded."
      return 0
    fi
    echo "Waiting for container count to increase..."
    _count=$(( _count + 1 ))
    sleep $_sleep_time_secs
  done

  echo "Timeout occurred before test was successful."
  return 1
}

