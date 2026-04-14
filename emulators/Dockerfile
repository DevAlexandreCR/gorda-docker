FROM eclipse-temurin:21-jdk AS java21

FROM node:20-bullseye

LABEL maintainer="devalexandrecr@gmail.com"

ENV JAVA_HOME=/opt/java/openjdk
ENV PATH="${JAVA_HOME}/bin:${PATH}"

USER root

RUN apt-get update -y && \
    apt-get install -y zsh ssl-cert openssl ca-certificates && \
    rm -rf /var/lib/apt/lists/*

COPY --from=java21 /opt/java/openjdk /opt/java/openjdk

RUN ln -sf /opt/java/openjdk/bin/java /usr/local/bin/java

RUN npm install --location=global npm@latest && \
    npm install --location=global firebase-tools

USER node

RUN mkdir -p /home/node/.npm-global && \
    npm config set prefix '/home/node/.npm-global'

ENV PATH="/home/node/.npm-global/bin:${JAVA_HOME}/bin:${PATH}"

RUN firebase setup:emulators:database \
    && firebase setup:emulators:storage \
    && firebase setup:emulators:ui

WORKDIR /workspace/admin

CMD ["tail", "-f", "/dev/null"]
