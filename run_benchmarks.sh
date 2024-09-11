#!/bin/bash

# Directory where the Locust scripts are stored
LOCUST_SCRIPTS_DIR="locust_scripts"
RESULTS_DIR="results"

# Create a directory for results if it doesn't exist
mkdir -p $RESULTS_DIR

# List of test configurations (script name, users, spawn rate, run time, csv prefix)
TEST_SCRIPTS=(
  "mean_latency_and_p95.py 50 10 5m latency_p95"
  "throughput_under_increasing_load.py 200 50 10m throughput"
  "high_load_for_cpu_measuring.py 500 100 10m high_load_cpu"
  "scalability_and_robustness_under_high_load.py 1000 100 15m scalability_robustness"
  "recover_after_high_load.py 300 50 5m recover_after_high_load"
  "text_generation.py 100 10 10m text_generation"
)

# Loop through each test and execute it with its specific configuration
echo "Starting benchmark tests..."

for test in "${TEST_SCRIPTS[@]}"; do
  # Split the configuration into individual components
  set -- $test
  script=$1
  users=$2
  spawn_rate=$3
  run_time=$4
  csv_prefix=$5

  echo "Running: $script with $users users, spawn rate $spawn_rate, for $run_time"

  # Run locust for the given script
  locust -f "$LOCUST_SCRIPTS_DIR/$script" --headless -u $users -r $spawn_rate --run-time $run_time --csv="$RESULTS_DIR/$csv_prefix" --host http://localhost:8080

  sleep 60
done

echo "Benchmark tests completed. Results are stored in the '$RESULTS_DIR' directory."
