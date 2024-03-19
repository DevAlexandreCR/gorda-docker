FROM debian:bullseye-slim

LABEL maintainer="devalexandrecr@gmail.com"

# Install necessary packages
RUN apt-get update && apt-get install -y \
    curl \
    git \
    ssh \
    zsh \
    chromium

# Install Node.js 18
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs

# Add SSH keys
COPY ssh_key_id_rsa /tmp/id_rsa
COPY ssh_key_id_rsa.pub /tmp/id_rsa.pub

RUN mkdir -p /root/.ssh && \
    cat /tmp/id_rsa.pub >> /root/.ssh/authorized_keys && \
    cat /tmp/id_rsa.pub >> /root/.ssh/id_rsa.pub && \
    cat /tmp/id_rsa >> /root/.ssh/id_rsa && \
    rm -f /tmp/id_rsa* && \
    chmod 644 /root/.ssh/authorized_keys /root/.ssh/id_rsa.pub && \
    chmod 400 /root/.ssh/id_rsa

# Configure SSH
RUN echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config && \
    ssh-keyscan github.com >> /root/.ssh/known_hosts && \
    echo "Host github.com\n  IdentityFile /root/.ssh/id_rsa" >> /root/.ssh/config

# Install Oh My Zsh for the node user

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh) --keep-zshrc" && \
    sed -i -r 's/^plugins=\(.*?\)$/plugins=(laravel5)/' /root/.zshrc && \
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
bindkey "^?" backward-delete-char\n' >> /root/.zshrc && \
    sh -c "git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions" && \
    sed -i 's~plugins=(~plugins=(zsh-autosuggestions ~g' /root/.zshrc && \
    sed -i '1iZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20' /root/.zshrc && \
    sed -i '1iZSH_AUTOSUGGEST_STRATEGY=(history completion)' /root/.zshrc && \
    sed -i '1iZSH_AUTOSUGGEST_USE_ASYNC=1' /root/.zshrc && \
    sed -i '1iTERM=xterm-256color' /root/.zshrc && \
    echo "" >> /root/.bashrc && \
    echo "" >> /root/.zshrc && \
    echo "" >> /root/.zshrc

USER root

ADD ./entrypoint.sh /
RUN chmod +x /entrypoint.sh

    # Install global dependencies
RUN npm install --location=global npm@latest && \
    npm install --location=global vue cli && \
    npm install --location=global firebase-tools

RUN npm install -g npm@latest \
    && npm install -g vue-cli \
    && npm install -g firebase-tools

RUN mkdir ~/.npm-global \
    && npm config set prefix '~/.npm-global'

ENV PATH $PATH:~/.node-bin
ENV PATH $PATH:/root/.node-bin
ENV PATH=~/.npm-global/bin:$PATH
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true
ENV CHROMIUM_PATH /usr/bin/chromium

# Copy necessary files
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
COPY emulators/dataEmulators /root/dataEmulators

## Clone repositories
RUN mkdir /root/apps
WORKDIR /root/apps

ENTRYPOINT ["/entrypoint.sh"]
#CMD ["tail", "-f", "/dev/null"]