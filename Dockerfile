FROM node:lts-alpine3.15

LABEL maintainer="devalexandrecr@gmail.com"

# Start as root
USER root

# create user no root
RUN set -xe; \
    apt-get update -yqq && \
    pecl channel-update pecl.php.net && \
    groupadd -g 1000 dev && \
    useradd -l -u 1000 -g dev -m dev -G docker_env && \
    usermod -p "*" dev -s /bin/bash

COPY ssh_key_id_rsa /tmp/id_rsa
COPY ssh_key_id_rsa.pub /tmp/id_rsa.pub
# install ssh key
RUN rm -f /etc/service/sshd/down && \
    cat /tmp/id_rsa.pub >> /root/.ssh/authorized_keys \
        && cat /tmp/id_rsa.pub >> /root/.ssh/id_rsa.pub \
        && cat /tmp/id_rsa >> /root/.ssh/id_rsa \
        && rm -f /tmp/id_rsa* \
        && chmod 644 /root/.ssh/authorized_keys /root/.ssh/id_rsa.pub \
    && chmod 400 /root/.ssh/id_rsa \
    && cp -rf /root/.ssh /home/threedsdock \
    && chown -R threedsdock:threedsdock /home/threedsdock/.ssh \