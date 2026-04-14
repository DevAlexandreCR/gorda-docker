FROM node:20-bullseye

LABEL maintainer="devalexandrecr@gmail.com"

USER root

RUN apt-get update && apt-get install -y \
    chromium \
    git \
    python3 \
    make \
    g++ \
    zsh \
    ca-certificates \
    openssl \
    && rm -rf /var/lib/apt/lists/*

RUN npm install --location=global npm@latest \
    && npm install --location=global firebase-tools

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV CHROMIUM_PATH=/usr/bin/chromium

WORKDIR /workspace

CMD ["tail", "-f", "/dev/null"]
