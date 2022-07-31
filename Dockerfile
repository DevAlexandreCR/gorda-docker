FROM node:16-alpine3.15

LABEL maintainer="devalexandrecr@gmail.com"

# Start as root
USER root

#Update APT repository & Install OpenSSH
RUN apk update \
    && apk --no-cache add openssh curl git

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
    && cp -rf /root/.ssh /home/node \
    && chown -R node:node /home/node/.ssh

RUN echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config && \
    ssh-keyscan github.com >> /home/node/.ssh/known_hosts && \
    echo "Host github.com \n IdentityFile /home/node/.ssh/id_rsa" >> /home/node/.ssh/config

# install node and git
USER root
    # Install global dependencies
RUN npm install --location=global npm@8.15.1 && \
    npm install --location=global vue cli && \
    npm install --location=global firebase-tools

# Install Zsh and java
RUN apk add zsh openjdk11

USER node

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh) --keep-zshrc" && \
    sed -i -r 's/^plugins=\(.*?\)$/plugins=(laravel5)/' /home/node/.zshrc && \
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
bindkey "^?" backward-delete-char\n' >> /home/node/.zshrc && \
    sh -c "git clone https://github.com/zsh-users/zsh-autosuggestions /home/node/.oh-my-zsh/custom/plugins/zsh-autosuggestions" && \
    sed -i 's~plugins=(~plugins=(zsh-autosuggestions ~g' /home/node/.zshrc && \
    sed -i '1iZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20' /home/node/.zshrc && \
    sed -i '1iZSH_AUTOSUGGEST_STRATEGY=(history completion)' /home/node/.zshrc && \
    sed -i '1iZSH_AUTOSUGGEST_USE_ASYNC=1' /home/node/.zshrc && \
    sed -i '1iTERM=xterm-256color' /home/node/.zshrc && \
    echo "" >> ~/.bashrc && \
    echo "" >> /home/node/.zshrc && \
    echo "" >> /home/node/.zshrc

USER root

ADD ./entrypoint.sh /

USER node

RUN mkdir ~/.npm-global \
    && npm config set prefix '~/.npm-global'

ENV PATH $PATH:/home/node/.node-bin
ENV PATH $PATH:/root/.node-bin
ENV PATH=~/.npm-global/bin:$PATH

COPY dataEmulators /home/node/dataEmulators

## clone repositories
RUN mkdir /home/node/apps

WORKDIR /home/node/apps

ENTRYPOINT ["/entrypoint.sh"]