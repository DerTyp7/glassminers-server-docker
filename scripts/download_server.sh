#!/bin/bash

EXEC=server.out

echo "[Info] Downloading latest server version..."
wget https://github.com/surrealtm/Glassminers/releases/latest/download/GMServer.out -O "$EXEC"

if [ $? -ne 0 ]; then
  echo "[Error] Download failed! Aborting."
  exit 1
fi

chmod +x "$EXEC"
echo "[Info] Download completed successfully."
