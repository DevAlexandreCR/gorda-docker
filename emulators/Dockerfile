FROM node:16-bullseye

LABEL maintainer="devalexandrecr@gmail.com"

# Start as root
USER root

# Install Zsh and java
RUN apt-get update -y && \
    mkdir /etc/ssl/certs/java/ && \
    apt install -y --reinstall -o Dpkg::Options::="--force-confask,confnew,confmiss" --reinstall ca-certificates-java ssl-cert openssl ca-certificates && \
    apt install -y openjdk-17-jdk openjdk-17-jre

    # Install global dependencies
RUN npm install --location=global npm@latest && \
    npm install --location=global firebase-tools

USER node

RUN mkdir ~/.npm-global \
    && npm config set prefix '~/.npm-global'

ENV PATH $PATH:/home/node/.node-bin
ENV PATH $PATH:/root/.node-bin
ENV PATH=~/.npm-global/bin:$PATH

RUN firebase setup:emulators:database \
    && firebase setup:emulators:storage \
    && firebase setup:emulators:ui \
    && firebase setup:emulators:pubsub

ADD ./entrypoint.sh /

COPY ./firebaseAccount.json /home/firebaseAccount.json

RUN mkdir /home/node/firebase

WORKDIR /home/node/firebase/admin

ENTRYPOINT ["/entrypoint.sh"]