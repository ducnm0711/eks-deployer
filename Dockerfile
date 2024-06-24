FROM ubuntu:jammy

RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    gnupg \
    jq \
    python3 \
    python3-pip \
    git \
    cron \
    sudo \
    default-jdk \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /opt/tools && mkdir -p /opt/work

# Define environment variables for the latest versions of Helm, kubectl, dsbulk, and cqlsh
ENV HELM_VERSION="v3.15.1" \
    HELM_SECRET_VERSION="v4.6.0" \
    HELM_DIFF_VERSION="v3.9.7" \
    KUBECTL_VERSION="v1.29.5" \
    YQ_VERSION="v4.44.1" \
    DSBULK_VERSION="1.11.0" \
    CQLSH_VERSION="6.8.48"

# Install helm, kubectl, awscli, yq
RUN cd /opt/work \
    && curl -LO "https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz" \
    && tar xzf helm-${HELM_VERSION}-linux-amd64.tar.gz \
    && mv linux-amd64/helm /opt/tools/helm \
    && curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" \
    && chmod +x kubectl \
    && mv kubectl /opt/tools/ \
    && curl -LO "https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64.tar.gz" \
    && tar xzf yq_linux_amd64.tar.gz \
    && mv yq_linux_amd64 /opt/tools/yq \
    && curl -OL "https://downloads.datastax.com/dsbulk/dsbulk-${DSBULK_VERSION}.tar.gz" \
    && tar xzf dsbulk-${DSBULK_VERSION}.tar.gz \
    && mv dsbulk-${DSBULK_VERSION} /opt/tools/dsbulk \
    && ln -s /opt/tools/dsbulk/bin/dsbulk /usr/local/bin/dsbulk \
    && curl -OL "https://downloads.datastax.com/enterprise/cqlsh-${CQLSH_VERSION}-bin.tar.gz" \
    && tar xzf cqlsh-${CQLSH_VERSION}-bin.tar.gz \
    && mv cqlsh-${CQLSH_VERSION} /opt/tools/cqlsh \
    && ln -s /opt/tools/cqlsh/bin/cqlsh /usr/local/bin/cqlsh \
    && curl -LO "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" \
    && unzip awscli-exe-linux-x86_64.zip \
    && ./aws/install \
    && rm -rf /opt/work

# Set environment variables
ENV PATH "/opt/tools:$PATH"

# Install helm plugins
RUN helm plugin install https://github.com/jkroepke/helm-secrets --version ${HELM_SECRET_VERSION} \
    && helm plugin install https://github.com/databus23/helm-diff --version ${HELM_DIFF_VERSION}

# Set working directory
WORKDIR /opt/tools
