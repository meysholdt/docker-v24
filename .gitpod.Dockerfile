FROM ubuntu:jammy

USER root

ADD https://raw.githubusercontent.com/gitpod-io/workspace-images/main/base/install-packages /usr/bin/install-packages
RUN chmod +x /usr/bin/install-packages

# Improve resilience during build (DNS timeouts, intermediate repo unavailability, broken proxy, etc.)
# Also, disable APT color output, and set the queue mode to 'host' to avoid issues with Docker's overlayfs.
# https://serverfault.com/questions/722893/debian-mirror-hash-sum-mismatch/743015#743015
RUN <<EOF cat >/etc/apt/apt.conf.d/99-gitpod
Acquire::Retries "10";
Acquire::https::Timeout "100";
Acquire::http::Pipeline-Depth "0";
Acquire::http::No-Cache=True;
Acquire::BrokenProxy=true;
APT::Color "0";
APT::Acquire::Queue-Mode "host";
Dpkg::Progress-Fancy "0";
EOF

RUN yes | unminimize \
    && install-packages \
    zip \
    git \
    unzip \
    bash-completion \
    build-essential \
    htop \
    iputils-ping \
    jq \
    less \
    locales \
    nano \
    ripgrep \
    software-properties-common \
    sudo \
    stow \
    time \
    emacs-nox \
    vim \
    multitail \
    lsof \
    ssl-cert \
    fish \
    zsh \
    shellcheck \
    curl \
    docker.io=24.0.5-0ubuntu1~22.04.1 \
    gnupg2 \
    isal \
    && locale-gen en_US.UTF-8

ENV LANG=en_US.UTF-8

# Create the gitpod user. UID must be 33333.
RUN useradd -l -u 33333 -G sudo -md /home/gitpod -s /bin/bash -p gitpod gitpod

USER gitpod
