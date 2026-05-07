FROM docker.io/library/ubuntu:26.04

LABEL project="toolbox" \
      os="ubuntu" \
      type="testing" \
      maintainer="yourname@example.com" \
      version="1.0"

RUN apt update -y \
    && apt upgrade -y \
    && apt install -y \
    sudo \
    vim \
    zsh

COPY --chown=root:root vimrc /root/.vimrc

ARG USERNAME=ubuntu
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Change to user
USER $USERNAME
WORKDIR /home/$USERNAME
