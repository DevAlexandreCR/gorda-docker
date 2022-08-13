#!/bin/sh
# This script checks if the container is started for the first time.
  echo "Run Emulators ..."
  cd /home/node/apps/admin || exit
  npm run start:emulators
