FROM ubuntu

LABEL maintainer="devalexandrecr@gmail.com"

# Start as root
USER root

#Update APT repository & Install OpenSSH
RUN apt-get update -y \
    && apt-get install -y ssh

#Establish the operating directory of OpenSSH
RUN mkdir /var/run/sshd

#Allow Root login
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' \
    /etc/ssh/sshd_config


#SSH login fix
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional \
    pam_loginuid.so@g' -i /etc/pam.d/sshd

#Set Root password
RUN echo 'root:root' | chpasswd

# create user no root
RUN set -xe; \
    groupadd -g 1000 dev && \
    useradd -l -u 1000 -g dev -m dev -G root && \
    usermod -p "*" dev -s /bin/bash

COPY ssh_key_id_rsa /tmp/id_rsa
COPY ssh_key_id_rsa.pub /tmp/id_rsa.pub

# install ssh key
RUN rm -f /etc/service/sshd/down \
    && mkdir /root/.ssh \
    && cat /tmp/id_rsa.pub >> /root/.ssh/authorized_keys \
        && cat /tmp/id_rsa.pub >> /root/.ssh/id_rsa.pub \
        && cat /tmp/id_rsa >> /root/.ssh/id_rsa \
        && rm -f /tmp/id_rsa* \
        && chmod 644 /root/.ssh/authorized_keys /root/.ssh/id_rsa.pub \
    && chmod 400 /root/.ssh/id_rsa \
    && cp -rf /root/.ssh /home/dev \
    && chown -R dev:dev /home/dev/.ssh \
    && ssh-keyscan github.com >> /home/dev/.ssh/known_hosts

# install node and git
USER root
ARG NODE_VERSION=16
ARG NVM_DIR=/home/dev/.nvm
RUN apt-get install curl -y \
    && mkdir -p $NVM_DIR \
    && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash \
        && . $NVM_DIR/nvm.sh \
        && nvm install ${NODE_VERSION} \
        && nvm use ${NODE_VERSION} \
        && nvm alias ${NODE_VERSION} \
        && apt install git -y

# Source NVM when loading bash since ~/.profile isn't loaded on non-login shell
RUN echo "" >> ~/.bashrc && \
    echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.bashrc && \
    echo '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm' >> ~/.bashrc

USER root
# Add NVM binaries to root's .bashrc
RUN echo "" >> ~/.bashrc && \
    echo 'export NVM_DIR="/home/dev/.nvm"' >> ~/.bashrc && \
    echo '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm' >> ~/.bashrc

ENV PATH $PATH:/home/dev/.node-bin

RUN find $NVM_DIR -type f -name node -exec ln -s {} /usr/local/bin/node \; && \
    NODE_MODS_DIR="$NVM_DIR/versions/node/$(node -v)/lib/node_modules" && \
    ln -s $NODE_MODS_DIR/bower/bin/bower /usr/local/bin/bower && \
    ln -s $NODE_MODS_DIR/gulp/bin/gulp.js /usr/local/bin/gulp && \
    ln -s $NODE_MODS_DIR/npm/bin/npm-cli.js /usr/local/bin/npm && \
    ln -s $NODE_MODS_DIR/npm/bin/npx-cli.js /usr/local/bin/npx && \
    ln -s $NODE_MODS_DIR/vue-cli/bin/vue /usr/local/bin/vue && \
    ln -s $NODE_MODS_DIR/vue-cli/bin/vue-init /usr/local/bin/vue-init && \
    ln -s $NODE_MODS_DIR/vue-cli/bin/vue-list /usr/local/bin/vue-list

# Instal global dependencies
#RUN npm install -g vue cli \
#    && npm install -g firebase-tools \

USER dev

## clone repositories
WORKDIR /home/dev
# Install functions

RUN eval "$(ssh-agent -s)"
RUN exec ssh-agent bash && ssh-add ~/.ssh/id_rsa
# install functions
RUN  git clone git@github.com:DevAlexandreCR/gorda-functions.git functions

WORKDIR /home/dev/functions

RUN npm install
#    && npm run build

WORKDIR /home/dev
# Install api
RUN  git clone git@github.com:DevAlexandreCR/gorda-api.git api

WORKDIR /home/dev/api

RUN npm install \
    && cp .env.example .env

WORKDIR /home/dev
# Install admin
RUN  git clone git@github.com:DevAlexandreCR/admin-driver.git admin

WORKDIR /home/dev/admin

RUN npm install \
    && cp .env.example .env

ENTRYPOINT ["tail", "-f", "/dev/null"]