FROM node:20-bookworm

LABEL maintainer="devalexandrecr@gmail.com"

USER root

RUN apt-get update && apt-get install -y \
    git \
    python3 \
    make \
    g++ \
    zsh \
    ca-certificates \
    openssl \
    && rm -rf /var/lib/apt/lists/*

RUN npm install --location=global npm@10 \
    && npm install --location=global firebase-tools

WORKDIR /workspace

CMD ["tail", "-f", "/dev/null"]
