# BuildKit Syntax
# syntax = docker/dockerfile:1.4

# Global arguments for build time
ARG PYTHON_VERSION=3.13.0-slim
ARG TERRAFORM_VERSION
ARG OC_VERSION

# Official Python base image
FROM python:${PYTHON_VERSION}

# Set arguments for non-privileged user
ARG UID=10001
ARG USER=devops

# Arguments to build time
ARG TERRAFORM_VERSION
ARG OC_VERSION
ARG BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ')
ARG VCS_REF=$(git rev-parse --short HEAD)
ARG VERSION=0.1.0

# Labels following OCI
LABEL org.opencontainers.image.created="${BUILD_DATE}" \
      org.opencontainers.image.revision="${VCS_REF}" \
      org.opencontainers.image.version="${VERSION}" \
      org.opencontainers.image.authors="DevOps Orphenix Team" \
      org.opencontainers.image.description="DevOps Tools Container" \
      org.opencontainers.image.source="https://github.com/ironwolphern/bastion"

# System dependencies installation
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl wget unzip git openssh-client sshpass ca-certificates jq sudo \
    && rm -rf /var/lib/apt/lists/*

# Tools installation
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt \
    && wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/local/bin/ \
    && rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && curl -LO "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/${OC_VERSION}/openshift-client-linux.tar.gz" \
    && tar xzf openshift-client-linux.tar.gz -C /usr/local/bin \
    && rm openshift-client-linux.tar.gz \
    && rm -Rf /usr/local/bin/README.md

# Create non-privileged user
RUN groupadd -g ${UID} ${USER} \
    && useradd -u ${UID} -g ${USER} -m -s /bin/bash ${USER} \
    && echo "${USER} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USER} \
    && chmod 0440 /etc/sudoers.d/${USER} \
    && mkdir -p /home/${USER}/.ansible /home/${USER}/.ssh \
    && chown -R ${USER}:${USER} /home/${USER}

# Copy configuration files
COPY --chown=${USER}:${USER} ansible.cfg /home/${USER}/.ansible/ansible.cfg
COPY --chown=${USER}:${USER} ssh_config /home/${USER}/.ssh/config

# Switch to non-privileged user
USER ${USER}
WORKDIR /home/${USER}

# Verification of tools installed
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD terraform version && kubectl version --client && ansible --version || exit 1

# Default command
CMD ["/bin/bash"]
