FROM ubuntu:jammy

# Install:
# - git (and git-lfs), for git operations (to e.g. push your work).
#   Also required for setting up your configured dotfiles in the workspace.
# - sudo, while not required, is recommended to be installed, since the
#   workspace user (`gitpod`) is non-root and won't be able to install
#   and use `sudo` to install any other tools in a live workspace.
# - docker v24
RUN apt-get update && apt-get install -yq \
    git \
    git-lfs \
    curl \
    gpg \
    lsb-release \
    sudo \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/*

# https://docs.docker.com/engine/install/ubuntu/
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && apt-get update \
    && apt-get install -yq docker-ce=5:25.0.2-1~ubuntu.22.04~jammy docker-ce-cli=5:25.0.2-1~ubuntu.22.04~jammy

RUN curl -o /usr/local/bin/docker-compose -fsSL https://github.com/docker/compose/releases/download/v2.24.1/docker-compose-linux-$(uname -m) \
    && chmod +x /usr/local/bin/docker-compose && mkdir -p /usr/local/lib/docker/cli-plugins && \
    ln -s /usr/local/bin/docker-compose /usr/local/lib/docker/cli-plugins/docker-compose

# Create the gitpod user. UID must be 33333.
RUN useradd -l -u 33333 -G sudo -md /home/gitpod -s /bin/bash -p gitpod gitpod

USER gitpod