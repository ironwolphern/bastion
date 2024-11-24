# BuildKit Syntax
# syntax = docker/dockerfile:1.4

# Global arguments for build time
ARG TERRAFORM_VERSION
ARG OC_VERSION
ARG GITHUB_SHA
ARG GITHUB_REF
ARG GITHUB_REPOSITORY
ARG GITHUB_ACTOR

# Use Ubuntu Noble as base image
FROM ubuntu:noble

# Set arguments for non-privileged user
ARG UID=10001
ARG USER=devops

# Labels following OCI
LABEL org.opencontainers.image.revision="${GITHUB_SHA}" \
      org.opencontainers.image.version="${GITHUB_REF}" \
      org.opencontainers.image.authors="${GITHUB_ACTOR}" \
      org.opencontainers.image.description="DevOps Tools Container" \
      org.opencontainers.image.source="${GITHUB_REPOSITORY}" \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.ref.name="${GITHUB_REF}" \
      org.opencontainers.image.vendor="GitHub"

# Environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Madrid

# System dependencies and Python installation
RUN apt-get update && apt-get install -y --no-install-recommends \
    software-properties-common=0.* curl=8.* unzip=6.* git=1:2.* openssh-client=1:9.* sshpass=1.* ca-certificates=20240203 vim=2:9.* jq=1.* sudo=1.* \
    && add-apt-repository -y ppa:deadsnakes/ppa \
    && apt-get update \
    && apt-get install -y --no-install-recommends python3.12=3.12.* python3-pip=24.* \
    && ln -sf /usr/bin/python3 /usr/bin/python \
    && rm -rf /var/lib/apt/lists/*

# Tools installation
COPY ../../requirements.txt "${HOME}"
RUN pip install --no-cache-dir -r "requirements.txt" \
    && curl -LO https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/local/bin/ \
    && rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && curl -LO "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/${OC_VERSION}/openshift-client-linux.tar.gz" \
    && tar xzf openshift-client-linux.tar.gz -C /usr/local/bin \
    && rm openshift-client-linux.tar.gz \
    && rm -Rf /usr/local/bin/README.md \
    && apt-get remove -y --purge unzip \
    && apt-get autoremove -y && apt-get clean -y

# Create non-privileged user
RUN groupadd -g ${UID} ${USER} \
    && useradd -u ${UID} -g ${USER} -lms /bin/bash ${USER} \
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
