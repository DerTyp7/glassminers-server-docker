#!/bin/bash

echo "[Info] Downloading server executable..."

LOCAL_EXECUTABLE_NAME="server_$1.out"

if [ "$1" = "stable" ]; then
  wget https://github.com/surrealtm/Glassminers/releases/latest/download/GMServer.out -O $LOCAL_EXECUTABLE_NAME
elif [ "$1" = "nightly" ]; then
  wget https://github.com/surrealtm/Glassminers/raw/refs/heads/main/run_tree/server.out -O $LOCAL_EXECUTABLE_NAME
else
  echo "[Error] Please provide either 'nightly' or 'stable' as an argument to this script."
  exit 1
fi

if [ $? -ne 0 ]; then
  echo "[Error] Download failed! Aborting."
  exit 1
fi

chmod 777 $LOCAL_EXECUTABLE_NAME

echo "[Info] Download completed successfully."
