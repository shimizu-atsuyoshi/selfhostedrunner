FROM ubuntu:22.04

ARG UID=1000
ARG USER=runner
ARG PASS=runner

# install systemd
RUN apt-get update && \
  apt-get install -y init systemd

# install docker
RUN apt-get update && \
  apt-get install -y ca-certificates curl && \
  install -m 0755 -d /etc/apt/keyrings && \
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc && \
  chmod a+r /etc/apt/keyrings/docker.asc && \
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null && \
  apt-get update && \
  apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin && \
  systemctl enable docker

# add runnner user
RUN apt-get -y install sudo && \
  useradd -m -u ${UID} ${USER} && \
  echo ${USER}:${PASS} | chpasswd && \
  echo "$USER ALL=(ALL) ALL" >> /etc/sudoers && \
  usermod -a -G docker ${USER}

# setup runner
WORKDIR /actions-runner
RUN curl -o actions-runner-linux-arm64-2.328.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.328.0/actions-runner-linux-arm64-2.328.0.tar.gz && \
  echo "b801b9809c4d9301932bccadf57ca13533073b2aa9fa9b8e625a8db905b5d8eb  actions-runner-linux-arm64-2.328.0.tar.gz" | shasum -a 256 -c && \
  tar xzf ./actions-runner-linux-arm64-2.328.0.tar.gz
