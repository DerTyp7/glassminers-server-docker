#!/bin/bash

MAX_LOGS=${MAX_LOGS:-20}
LOG_DIR=${LOG_DIR:-"/var/log/glassminers"}
LOG_DATE_FORMAT=${LOG_DATE_FORMAT:-"%Y-%m-%d-%H-%M-%S"}
WATCHDOG_ENABLED=${WATCHDOG_ENABLED:-false}
MAX_RETRIES=${MAX_RETRIES:-10}

mkdir -p "$LOG_DIR"

delete_old_logs() {
  if [ -d "$LOG_DIR" ]; then
    NUM_LOGS=$(ls -1q "$LOG_DIR"/*.log 2>/dev/null | wc -l)

    if ((NUM_LOGS > MAX_LOGS)); then
      OLDEST_LOGS=$(ls -1t "$LOG_DIR"/*.log | tail -n $((NUM_LOGS - MAX_LOGS)))
      for log_file in $OLDEST_LOGS; do
        rm "$log_file"
        echo "[Info] Removed old log: $log_file"
      done
    fi
  fi
}

rename_log() {
  if [ -f "$LOG_DIR/latest.log" ]; then
    STOP_TIMESTAMP=$(date +"$LOG_DATE_FORMAT")
    mv "$LOG_DIR/latest.log" "$LOG_DIR/$STOP_TIMESTAMP.log"
    echo "[Info] Renamed latest.log to $STOP_TIMESTAMP.log"
  else
    echo "[Warning] No latest.log file to rename"
  fi
}

clean_up() {
  rename_log
  delete_old_logs
}

trap 'clean_up; shutdown_requested=true; kill -TERM $SERVER_PID' SIGTERM SIGINT

echo "[Info] Max number of logs set to $MAX_LOGS"
echo "[Info] Watchdog enabled: $WATCHDOG_ENABLED"
echo "[Info] Max retries: $MAX_RETRIES"

shutdown_requested=false
retry_count=0
while true; do
  TIMESTAMP=$(date +"$LOG_DATE_FORMAT")
  echo "[Info] Server is starting at [$TIMESTAMP]"

  $EXEC >"$LOG_DIR/latest.log" 2>&1 &
  SERVER_PID=$!

  wait $SERVER_PID
  EXIT_STATUS=$?

  echo "[Info] Server stopped at [$(date +"$LOG_DATE_FORMAT")] with exit code: $EXIT_STATUS"

  if [ "$shutdown_requested" = true ] || [ $EXIT_STATUS -eq 0 ]; then
    break
  fi

  if [ "$WATCHDOG_ENABLED" = true ]; then
    if [ $retry_count -lt $MAX_RETRIES ]; then
      retry_count=$((retry_count + 1))
      clean_up
      echo "[Warning] Watchdog restarting server after crash (attempt $retry_count/$MAX_RETRIES)"
      sleep 5
    else
      echo "[Error] Max retries reached ($MAX_RETRIES). Watchdog stopping."
      break
    fi
  else
    break
  fi
done

clean_up
echo "[Info] Watchdog script exiting"
