# BuildKit Syntax
# syntax = docker/dockerfile:1.4

# Global arguments for build time
ARG TERRAFORM_VERSION
ARG OC_VERSION
ARG GITHUB_SHA
ARG GITHUB_REF
ARG GITHUB_REPOSITORY

# Use Red Hat UBI9 minimal as base
FROM registry.access.redhat.com/ubi9-minimal:latest

# Set arguments for non-privileged user
ARG UID=10001
ARG USER=devops

# Labels following OCI
LABEL org.opencontainers.image.revision="${GITHUB_SHA}" \
      org.opencontainers.image.version="${GITHUB_REF}" \
      org.opencontainers.image.authors="ironwolphern" \
      org.opencontainers.image.description="DevOps Tools Container" \
      org.opencontainers.image.source="https://github.com/ironwolphern/bastion" \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.ref.name="${GITHUB_REF}" \
      org.opencontainers.image.vendor="GitHub"

# System dependencies installation
RUN microdnf update -y \
    && microdnf install -y wget tar unzip git openssh-clients sshpass ca-certificates vim jq sudo python3.12 python3.12-pip \
    && ln -sf /usr/bin/python3.12 /usr/bin/python3 \
    && ln -sf /usr/bin/python3 /usr/bin/python \
    && ln -sf /usr/bin/pip3.12 /usr/bin/pip3 \
    && ln -sf /usr/bin/pip3 /usr/bin/pip

# Tools installation
COPY ../../requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt \
    && wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/local/bin/ \
    && rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && curl -LO "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/${OC_VERSION}/openshift-client-linux.tar.gz" \
    && tar xzf openshift-client-linux.tar.gz -C /usr/local/bin \
    && rm openshift-client-linux.tar.gz \
    && rm -Rf /usr/local/bin/README.md \
    && microdnf remove -y wget tar unzip \
    && microdnf clean all

# Create non-privileged user
RUN groupadd -g ${UID} ${USER} \
    && useradd -u ${UID} -g ${USER} -m -s /bin/bash ${USER} \
    && echo "${USER} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USER} \
    && chmod 0440 /etc/sudoers.d/${USER} \
    && mkdir -p /home/${USER}/.ansible /home/${USER}/.ssh /home/${USER}/.kube /home/${USER}/.terraform.d \
    && chown -R ${USER}:${USER} /home/${USER}

# Copy configuration files
COPY --chown=${USER}:${USER} ../../ansible.cfg /home/${USER}/.ansible/ansible.cfg
COPY --chown=${USER}:${USER} ../../ssh_config /home/${USER}/.ssh/config

# Switch to non-privileged user
USER ${USER}
WORKDIR /home/${USER}

# Copy entrypoint script
COPY ../../entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

# Verification of tools installed
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD terraform version && kubectl version --client && ansible --version || exit 1

# Default command
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/bin/bash"]
