#!/bin/bash

VERSION=${VERSION:- "latest"}

echo "[Info] Downloading server (${VERSION})..."

if [ "$VERSION" = "latest" ]; then
    wget https://github.com/surrealtm/Glassminers/releases/latest/download/GMServer.out -O "server.out"

else
    wget https://github.com/surrealtm/Glassminers/releases/download/${VERSION}/GMServer.out -O "server.out"
fi

if [ $? -ne 0 ]; then
  echo "[Error] Download failed! Aborting."
  exit 1
fi

chmod 777 ./server.out

echo "[Info] Download completed successfully."
