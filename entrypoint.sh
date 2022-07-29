#!/bin/sh
# This script checks if the container is started for the first time.

CONTAINER_FIRST_STARTUP="CONTAINER_FIRST_STARTUP"
if [ ! -e /home/dev/apps/$CONTAINER_FIRST_STARTUP ]; then
    touch /home/dev/apps/$CONTAINER_FIRST_STARTUP
    echo "installing apps..."
    rm -rf functions || exit && rm -rf api || exit && rm -rf admin || exit && \
    git clone git@github.com:DevAlexandreCR/gorda-functions.git functions && \
    git clone git@github.com:DevAlexandreCR/gorda-api.git api && \
    git clone git@github.com:DevAlexandreCR/admin-driver.git admin

    # Install global dependencies
    npm install --location=global npm@8.15.0 && \
    npm install --location=global vue cli && \
    npm install --location=global firebase-tools

    #######################################################
    ######################  FUNCTIONS  ###########################
    #######################################################

    echo "installing functions..."

    cd /home/dev/apps/functions || exit
    git checkout develop && npm install --no-interaction && \
    npm run build
#    sed -i 's/APP_NAME=Laravel/APP_NAME=DServer/' .env && \

    #######################################################
    ######################  API  ##########################
    #######################################################

    echo "installing Api..."
    cd /home/dev/apps/api || exit
    git checkout develop && \
    cp .env.example .env && cp .env.example .env.testing && \
    npm install --no-interaction
#    sed -i 's/VISA_CAVV_A=/VISA_CAVV_A="0131517010204061"/' .env && \

    #######################################################
    ######################  ADMIN  ##########################
    #######################################################

    echo "installing Admin..."
    cd /home/dev/apps/admin || exit
    chmod -R 777 .

    git checkout develop && \
    cp .env.example .env.local && cp .env.example .env.testing && cp .env.example .env.production && \
    npm install --no-interaction
#    sed -i 's/APP_URL=http:\/\/localhost\//APP_URL=http:\/\/mpi.test/' .env && \

    cd /home/dev/apps/admin || exit
    cp -r /home/dev/dataEmulators dataEmulators && \
    echo "installation ended"

else
  echo "Apps running..."
  cd /home/dev/apps/admin || exit
  npm run start:emulators
#  tail -f /dev/null
fi
