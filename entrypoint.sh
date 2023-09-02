#!/bin/sh
# This script checks if the container is started for the first time.

CONTAINER_FIRST_STARTUP="CONTAINER_FIRST_STARTUP"
if [ ! -e /home/node/apps/$CONTAINER_FIRST_STARTUP ]; then
    echo "installing apps..."
    rm -rf functions || exit && rm -rf api || exit && rm -rf admin || exit && \
    git clone git@github.com:DevAlexandreCR/gorda-functions.git functions && \
    git clone git@github.com:DevAlexandreCR/gorda-api.git api && \
    git clone git@github.com:DevAlexandreCR/admin-driver.git admin

    #######################################################
    ######################  FUNCTIONS  ###########################
    #######################################################

    echo "installing functions..."

    cd /home/node/apps/functions || exit
    git checkout develop && npm install --no-interaction && \
    npm run build

    #######################################################
    ######################  API  ##########################
    #######################################################

    echo "installing Api..."
    cd /home/node/apps/api || exit
    git checkout develop && \
    cp .env.example .env && cp .env.example .env.testing && \
    npm install --no-interaction && \
    npm run build

    #######################################################
    ######################  ADMIN  ##########################
    #######################################################

    echo "installing Admin..."
    cd /home/node/apps/admin || exit

    git checkout develop && \
    cp .env.example .env.local && cp .env.example .env.testing && cp .env.example .env.production && \
    cp firebase.example.json firebase.json
    npm install --no-interaction && \
#    sed -i 's/"host": "127.0.0.1"/"host": "0.0.0.0"/' firebase.json && \
    cp -r /home/node/dataEmulators dataEmulators && \
    touch /home/node/apps/$CONTAINER_FIRST_STARTUP && \
    echo "installation ended"

else
  echo "Apps running..."
  cd /home/node/apps/admin || exit
  tail -f /dev/null
fi
