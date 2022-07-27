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
#    sed -i 's/DS_URL=/DS_URL=http:\/\/dserver.test\/api\/result-request/' .env && \
#    sed -i 's/ACS_URL=/ACS_URL=http:\/\/acs.test\/api\/v1\/authenticate/' .env && \
#    sed -i 's/ACS_TIMEOUT=/ACS_TIMEOUT=20/' .env && \
#    sed -i 's/DS_REFERENCE_NUMBER=/DS_REFERENCE_NUMBER=3DS_LOA_DIS_PPFU_020100_00010/' .env && \
#    sed -i 's/APP_URL=http:\/\/localhost/APP_URL=http:\/\/dserver.test/' .env && \
#    sed -i 's/DB_CONNECTION=mysql/DB_CONNECTION=mysql/' .env && \
#    sed -i 's/DB_HOST=127.0.0.1/DB_HOST=mysql/' .env && \
#    sed -i 's/DB_DATABASE=laravel/DB_DATABASE=3ds-ds/' .env && \
#    sed -i 's/DB_USERNAME=root/DB_USERNAME=default/' .env && \
#    sed -i 's/DB_PASSWORD=/DB_PASSWORD=secret/' .env && \
#    sed -i 's/CACHE_DRIVER=file/CACHE_DRIVER=redis/' .env && \
#    sed -i 's/SESSION_DRIVER=file/SESSION_DRIVER=redis/' .env && \
#    sed -i 's/REDIS_HOST=127.0.0.1/REDIS_HOST=redis/' .env && \

    #######################################################
    ######################  API  ##########################
    #######################################################

    echo "installing Api..."
    cd /home/dev/apps/api || exit
    git checkout develop && \
    cp .env.example .env && cp .env.example .env.testing && \
    npm install --no-interaction
#    sed -i 's/VISA_CAVV_A=/VISA_CAVV_A="0131517010204061"/' .env && \
#    sed -i 's/VISA_CAVV_B=/VISA_CAVV_B="91B0D0F180A1C1E0"/' .env && \
#    sed -i 's/APP_URL=http:\/\/localhost\//APP_URL=http:\/\/acs.test/' .env && \
#    sed -i 's/DB_HOST=127.0.0.1/DB_HOST=mysql/' .env && \
#    sed -i 's/DB_DATABASE=acs/DB_DATABASE=3ds-acs/' .env && \
#    sed -i 's/DB_USERNAME=acs_user/DB_USERNAME=default/' .env && \
#    sed -i 's/DB_PASSWORD=acs_password/DB_PASSWORD=secret/' .env && \
#    sed -i 's/DB_HOST=127.0.0.1/DB_HOST=mysql/' .env.testing && \
#    sed -i 's/DB_DATABASE=acs/DB_DATABASE=testing/' .env.testing && \
#    sed -i 's/DB_USERNAME=acs_user/DB_USERNAME=default/' .env.testing && \
#    sed -i 's/DB_PASSWORD=acs_password/DB_PASSWORD=secret/' .env.testing && \
#    sed -i 's/CACHE_DRIVER=redis/CACHE_DRIVER=redis/' .env && \
#    sed -i 's/SESSION_DRIVER=redis/SESSION_DRIVER=redis/' .env && \
#    sed -i 's/REDIS_HOST=redis/REDIS_HOST=redis/' .env && \
#    sed -i 's/ID_BXMAS=/ID_BXMAS=1/' .env && \

    #######################################################
    ######################  ADMIN  ##########################
    #######################################################

    echo "installing Admin..."
    cd /home/dev/apps/admin || exit
    chmod -R a+w .
    chmod a+w build

    git checkout develop && \
    cp .env.example .env.local && cp .env.example .env.testing && cp .env.example .env.production && \
    npm install --no-interaction
#    sed -i 's/APP_URL=http:\/\/localhost\//APP_URL=http:\/\/mpi.test/' .env && \
#    sed -i 's/APP_DEBUG=false/APP_DEBUG=true/' .env && \
#    sed -i 's/DB_HOST=127.0.0.1/DB_HOST=mysql/' .env && \
#    sed -i 's/DB_DATABASE=homestead/DB_DATABASE=3ds-mpi/' .env && \
#    sed -i 's/DB_USERNAME=homestead/DB_USERNAME=default/' .env && \
#    sed -i 's/DB_PASSWORD=secret/DB_PASSWORD=secret/' .env && \
#    sed -i 's/DB_HOST=127.0.0.1/DB_HOST=mysql/' .env.testing && \
#    sed -i 's/DB_DATABASE=mpi/DB_DATABASE=testing/' .env.testing && \
#    sed -i 's/DB_USERNAME=mpi-user/DB_USERNAME=default/' .env.testing && \
#    sed -i 's/DB_PASSWORD=mpi-password/DB_PASSWORD=secret/' .env.testing && \
#    sed -i 's/CACHE_DRIVER=file/CACHE_DRIVER=redis/' .env && \
#    sed -i 's/SESSION_DRIVER=file/SESSION_DRIVER=redis/' .env && \
#    sed -i 's/REDIS_HOST=127.0.0.1/REDIS_HOST=redis/' .env && \
#    sed -i 's/PTP_LOGIN=/PTP_LOGIN=dnetix/' .env && \

    echo "installation ended"

else
  echo "Apps running..."
  tail -f /dev/null
fi
