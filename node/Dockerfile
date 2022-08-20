FROM node:16-alpine3.15

USER root

# Install global dependencies
RUN npm install --location=global npm@latest && \
    npm install --location=global @vue/cli && \
    npm install --location=global typescript

CMD ["tail", "-f", "/dev/null"]