#!/bin/sh
# This script checks if the container is started for the first time.

CONTAINER_FIRST_STARTUP="CONTAINER_FIRST_STARTUP"
if [ ! -e /root/apps/$CONTAINER_FIRST_STARTUP ]; then
    echo "installing apps..."
    rm -rf functions || exit && rm -rf api || exit && rm -rf admin || exit && \
    git clone git@github.com:DevAlexandreCR/gorda-functions.git functions && \
    git clone git@github.com:DevAlexandreCR/gorda-api.git api && \
    git clone git@github.com:DevAlexandreCR/admin-driver.git admin

    # Change owner and permissions
    chown -R $USER:$USER /root/apps/functions
    chown -R $USER:$USER /root/apps/api
    chown -R $USER:$USER /root/apps/admin
    chmod -R 777 /root/apps/functions
    chmod -R 777 /root/apps/api
    chmod -R 777 /root/apps/admin

    #######################################################
    ######################  FUNCTIONS  ###########################
    #######################################################

    echo "installing functions..."

    cd /root/apps/functions || exit
    npm cache clean -force && \
    git checkout develop && npm install --no-interaction && \
    npm run build

    #######################################################
    ######################  API  ##########################
    #######################################################

    echo "installing Api..."
    cd /root/apps/api || exit
    git checkout develop && \
    cp .env.example .env && cp .env.example .env.testing && \
    npm install --no-interaction && \
    npm run build

    #######################################################
    ######################  ADMIN  ##########################
    #######################################################

    echo "installing Admin..."
    cd /root/apps/admin || exit

    # git checkout develop && \
    cp .env.example .env.local && cp .env.example .env.testing && cp .env.example .env.production && \
    cp firebase.example.json firebase.json && \
    npm install --no-interaction && \
    sed -i 's/"host": "127.0.0.1"/"host": "0.0.0.0"/' firebase.json && \
    cp -r /root/dataEmulators dataEmulators && \
    touch /root/apps/$CONTAINER_FIRST_STARTUP && \
    echo "installation ended"

else
  echo "Apps running..."
  cp -r /root/dataEmulators dataEmulators
  cd /root/apps/admin || exit
  tail -f /dev/null
fi
