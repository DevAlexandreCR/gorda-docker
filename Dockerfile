FROM ubuntu

LABEL maintainer="devalexandrecr@gmail.com"

# Start as root
USER root

#Update APT repository & Install OpenSSH
RUN apt-get update -y \
    && apt-get install -y ssh

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
    && chown -R dev:dev /home/dev/.ssh

RUN echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config && \
    ssh-keyscan github.com >> /home/dev/.ssh/known_hosts && \
    echo "Host github.com \n IdentityFile /home/dev/.ssh/id_rsa" >> /home/dev/.ssh/config

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
        && apt install git -y \
        && chmod -R a+w /home/dev/.nvm/ \
        && chmod a+w /home/dev/.nvm/

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

# Install Zsh
RUN apt install -y zsh

USER dev

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh) --keep-zshrc" && \
    sed -i -r 's/^plugins=\(.*?\)$/plugins=(laravel5)/' /home/dev/.zshrc && \
    echo '\n\
bindkey "^[OB" down-line-or-search\n\
bindkey "^[OC" forward-char\n\
bindkey "^[OD" backward-char\n\
bindkey "^[OF" end-of-line\n\
bindkey "^[OH" beginning-of-line\n\
bindkey "^[[1~" beginning-of-line\n\
bindkey "^[[3~" delete-char\n\
bindkey "^[[4~" end-of-line\n\
bindkey "^[[5~" up-line-or-history\n\
bindkey "^[[6~" down-line-or-history\n\
bindkey "^?" backward-delete-char\n' >> /home/dev/.zshrc && \
    sh -c "git clone https://github.com/zsh-users/zsh-autosuggestions /home/dev/.oh-my-zsh/custom/plugins/zsh-autosuggestions" && \
    sed -i 's~plugins=(~plugins=(zsh-autosuggestions ~g' /home/dev/.zshrc && \
    sed -i '1iZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20' /home/dev/.zshrc && \
    sed -i '1iZSH_AUTOSUGGEST_STRATEGY=(history completion)' /home/dev/.zshrc && \
    sed -i '1iZSH_AUTOSUGGEST_USE_ASYNC=1' /home/dev/.zshrc && \
    sed -i '1iTERM=xterm-256color' /home/dev/.zshrc && \
    echo "" >> /home/dev/.zshrc && \
    echo "" >> /home/dev/.zshrc

USER root

# Clean up
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    rm /var/log/lastlog /var/log/faillog


ADD ./entrypoint.sh /

USER dev

## clone repositories
RUN mkdir /home/dev/apps

WORKDIR /home/dev/apps

ENTRYPOINT ["/entrypoint.sh"]