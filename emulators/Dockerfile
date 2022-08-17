FROM node:16-alpine3.15

LABEL maintainer="devalexandrecr@gmail.com"

# Start as root
USER root

# Install Zsh and java
RUN apk add openjdk11

    # Install global dependencies
RUN npm install --location=global npm@latest && \
    npm install --location=global firebase-tools

USER node

RUN mkdir ~/.npm-global \
    && npm config set prefix '~/.npm-global'

ENV PATH $PATH:/home/node/.node-bin
ENV PATH $PATH:/root/.node-bin
ENV PATH=~/.npm-global/bin:$PATH

RUN firebase setup:emulators:database
RUN firebase setup:emulators:ui


RUN mkdir /home/node/apps

WORKDIR /home/node/firebase/admin

ENTRYPOINT ["npm", "run", "start:emulators"]