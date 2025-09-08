# Use Ubuntu as base image
FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV PIPENV_VENV_IN_PROJECT=1

# Set working directory
WORKDIR /app

# Update package list and install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    python3 \
    python3-dev \
    python3-pip \
    python3-venv \
    zsh \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install pipenv
RUN pip3 install pipenv

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

# Expose port (adjust as needed for your future application)
EXPOSE 8000

# Keep container running - you can create your app later
CMD ["tail", "-f", "/dev/null"]
