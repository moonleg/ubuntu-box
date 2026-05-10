FROM docker.io/library/ubuntu:26.04

LABEL project="toolbox" \
      os="ubuntu" \
      type="testing" \
      maintainer="yourname@example.com" \
      version="1.0"

RUN apt-get update -y \
    && apt-get upgrade -y \
    && apt-get install -yq --no-install-recommends \
    sudo \
    vim \
    vim-tiny \
    vim-runtime \
    vim-common \
    man-db \
    zsh \
    locales \
    && locale-gen en_US.UTF-8 \
    && update-locale LANG=en_US.UTF-8 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY --chown=root:root vimrc /root/.vimrc

ARG DEBIAN_FRONTEND=noninteractive
ARG USERNAME=ubuntu
ARG USER_UID=1000
ARG USER_GID=$USER_UID
ARG DEBCONF_NOWARNINGS=yes
ENV DEBIAN_FRONTEND=${DEBIAN_FRONTEND} \
DEBCONF_NOWARNINGS=${DEBCONF_NOWARNINGS} \
TZ=Etc/UTC \
TERM=xterm \
PATH="/home/${USERNAME}/.local/bin:${PATH}"

RUN echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/$USERNAME && \
    chmod 0440 /etc/sudoers.d/$USERNAME

# Change to user
USER $USERNAME
WORKDIR /home/$USERNAME

COPY --chown=$USERNAME:$USERNAME vimrc /home/$USERNAME/.vimrc
COPY --chown=$USERNAME:$USERNAME zshrc /home/$USERNAME/.zshrc

RUN mkdir -p /home/$USERNAME/shared /home/$USERNAME/.ssh && \
    chmod 755 /home/$USERNAME/shared && \
    chmod 0700 /home/$USERNAME/.ssh && \
    touch /home/${USERNAME}/.hushlogin && \ 
    mkdir -p /home/${USERNAME}/.local/bin

ENV PATH="/home/${USERNAME}/.local/bin:${PATH}"

ENTRYPOINT ["/bin/zsh", "-c", "sleep infinity"]
CMD ["-l"]
