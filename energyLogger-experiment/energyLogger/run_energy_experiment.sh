#!/bin/bash

APP="$1"
SAMPLEPERIOD=0.05
TS=$(date +"%Y%m%d_%H%M%S")

case "$APP" in

  # --------------------------------------------------
  # JavaScript
  # --------------------------------------------------

  cakeshop|javascript-cakeshop)
    LANGUAGE="javascript"
    VARIANT="cakeshop"
    WORKLOAD_SCRIPT="../workloads/run_cakeshop_workload.sh"
    ;;

  cakeshop-compressed|javascript-cakeshop-compressed)
    LANGUAGE="javascript"
    VARIANT="cakeshop-compressed"
    WORKLOAD_SCRIPT="../workloads/run_cakeshop_compressed_workload.sh"
    ;;


  # --------------------------------------------------
  # Java
  # --------------------------------------------------

  java-cakeshop)
    LANGUAGE="java"
    VARIANT="cakeshop"
    WORKLOAD_SCRIPT="../workloads/run_java_cakeshop_workload.sh"
    ;;

  java-cakeshop-compressed)
    LANGUAGE="java"
    VARIANT="cakeshop-compressed"
    WORKLOAD_SCRIPT="../workloads/run_java_cakeshop_compressed_workload.sh"
    ;;


  # --------------------------------------------------
  # C#
  # --------------------------------------------------

  csharp-cakeshop)
    LANGUAGE="csharp"
    VARIANT="cakeshop"
    WORKLOAD_SCRIPT="../workloads/run_csharp_cakeshop_workload.sh"
    ;;

  csharp-cakeshop-compressed)
    LANGUAGE="csharp"
    VARIANT="cakeshop-compressed"
    WORKLOAD_SCRIPT="../workloads/run_csharp_cakeshop_compressed_workload.sh"
    ;;


  # --------------------------------------------------
  # Laravel
  # --------------------------------------------------

  laravel-cakeshop)
    LANGUAGE="laravel"
    VARIANT="cakeshop"
    WORKLOAD_SCRIPT="../workloads/run_laravel_cakeshop_workload.sh"
    ;;

  laravel-cakeshop-compressed)
    LANGUAGE="laravel"
    VARIANT="cakeshop-compressed"
    WORKLOAD_SCRIPT="../workloads/run_laravel_cakeshop_compressed_workload.sh"
    ;;


  # --------------------------------------------------
  # Invalid argument
  # --------------------------------------------------

  *)
    echo "Usage:"
    echo "  $0 javascript-cakeshop"
    echo "  $0 javascript-cakeshop-compressed"
    echo "  $0 java-cakeshop"
    echo "  $0 java-cakeshop-compressed"
    echo "  $0 csharp-cakeshop"
    echo "  $0 csharp-cakeshop-compressed"
    echo "  $0 laravel-cakeshop"
    echo "  $0 laravel-cakeshop-compressed"
    echo ""
    echo "Legacy JavaScript commands are also supported:"
    echo "  $0 cakeshop"
    echo "  $0 cakeshop-compressed"
    exit 1
    ;;
esac


# --------------------------------------------------
# Result directories
# --------------------------------------------------

RESULT_DIR="./results/$LANGUAGE/$VARIANT"
LOG_DIR="./logs/$LANGUAGE"

mkdir -p "$RESULT_DIR"
mkdir -p "$LOG_DIR"


# --------------------------------------------------
# File names
# --------------------------------------------------

SAFE_VARIANT=$(echo "$VARIANT" | tr '-' '_')

OUTFILE="$RESULT_DIR/${LANGUAGE}_${SAFE_VARIANT}_${SAMPLEPERIOD}s_${TS}.csv"

PERF_OUT="$LOG_DIR/${LANGUAGE}_${SAFE_VARIANT}_${SAMPLEPERIOD}s_${TS}_perf.txt"


# --------------------------------------------------
# Check workload
# --------------------------------------------------

if [ ! -f "$WORKLOAD_SCRIPT" ]; then
  echo "Error: workload script not found:"
  echo "$WORKLOAD_SCRIPT"
  exit 1
fi


# --------------------------------------------------
# EnergyLogger
# --------------------------------------------------

./pmic_raw_logger "$SAMPLEPERIOD" "$OUTFILE" &
LOGGER_PID=$!

echo "Logger started with PID $LOGGER_PID"
echo "Language: $LANGUAGE"
echo "Variant: $VARIANT"
echo "Logging to: $OUTFILE"

sleep 1


# --------------------------------------------------
# Start measurement
# --------------------------------------------------

kill -USR1 "$LOGGER_PID"
echo "Measurement started"


# --------------------------------------------------
# Run workload with perf
# --------------------------------------------------

perf stat -o "$PERF_OUT" \
  -e task-clock,cycles,instructions,cache-misses \
  -- bash "$WORKLOAD_SCRIPT" &

WORK_PID=$!

echo "Workload PID: $WORK_PID"

wait "$WORK_PID"


# --------------------------------------------------
# Stop measurement
# --------------------------------------------------

kill -USR2 "$LOGGER_PID"
echo "Measurement stopped"

kill -TERM "$LOGGER_PID"
wait "$LOGGER_PID"


# --------------------------------------------------
# Finished
# --------------------------------------------------

echo ""
echo "Experiment complete."
echo "EnergyLogger data:"
echo "$OUTFILE"
echo ""
echo "Perf data:"
echo "$PERF_OUT"