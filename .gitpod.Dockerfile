FROM ubuntu:jammy

RUN apt-get update && apt-get install -yq \
    git \
    git-lfs \
    curl \
    gpg \
    sudo \
    lsb-release \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/*

# Create the gitpod user. UID must be 33333.
RUN useradd -l -u 33333 -G sudo -md /home/gitpod -s /bin/bash -p gitpod gitpod


# copied from https://github.com/gitpod-io/workspace-images/blob/main/chunks/tool-docker/Dockerfile
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && apt-get update \
    && apt-get install -yq docker-ce=5:24.0.9-1~ubuntu.22.04~jammy docker-ce-cli=5:24.0.9-1~ubuntu.22.04~jammy containerd.io docker-buildx-plugin \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/*

RUN curl -o /usr/local/bin/docker-compose -fsSL https://github.com/docker/compose/releases/download/v2.24.1/docker-compose-linux-$(uname -m) \
    && chmod +x /usr/local/bin/docker-compose && mkdir -p /usr/local/lib/docker/cli-plugins && \
    ln -s /usr/local/bin/docker-compose /usr/local/lib/docker/cli-plugins/docker-compose


USER gitpod