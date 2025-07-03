#!/bin/bash

echo "[Info] Downloading latest server version..."
wget https://github.com/surrealtm/Glassminers/releases/latest/download/GMServer.out -O "server.out"

if [ $? -ne 0 ]; then
  echo "[Error] Download failed! Aborting."
  exit 1
fi

echo "[Info] Download completed successfully."
