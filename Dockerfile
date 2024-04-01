FROM ubuntu:jammy

RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    gpg \
    jq \
    python3 \
    python3-pip \
    git \
    cron \
    sudo \
    default-jdk \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /opt/tools && mkdir -p /opt/work

RUN cd /opt/work && curl -LO "https://get.helm.sh/helm-v3.11.2-linux-amd64.tar.gz"  && tar xzf helm-v3.11.2-linux-amd64.tar.gz \
&& curl -LO "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip"  && unzip awscli-exe-linux-x86_64.zip && ./aws/install \
&& curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.26.0/bin/linux/amd64/kubectl && chmod a+x kubectl \
&& mv kubectl /opt/tools/ && mv linux-amd64/helm /opt/tools/ && rm -rf /opt/work
RUN pip3 install yq kubernetes cqlsh

ENV PATH "/opt/tools:$PATH"
RUN helm plugin install https://github.com/futuresimple/helm-secrets
RUN helm plugin install https://github.com/databus23/helm-diff
WORKDIR /opt/tools
