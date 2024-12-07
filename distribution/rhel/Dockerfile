# BuildKit Syntax
# syntax = docker/dockerfile:1.10

# Global arguments for build time
ARG TERRAFORM_VERSION
ARG OC_VERSION

# Use Red Hat UBI9 minimal as base
FROM registry.access.redhat.com/ubi9-minimal:9.5

ARG TERRAFORM_VERSION
ARG OC_VERSION

# Set arguments for non-privileged user
ARG UID=10001
ARG USER=devops

# System dependencies installation
RUN microdnf update -y \
    && microdnf install -y tar-2:1.* unzip-6.* git-2.* openssh-clients-8.* sshpass-1.* jq-1.* sudo-1.* python3.12-3.12.* python3.12-pip-23.* \
    && ln -sf /usr/bin/python3.12 /usr/bin/python3 \
    && ln -sf /usr/bin/python3 /usr/bin/python \
    && ln -sf /usr/bin/pip3.12 /usr/bin/pip3 \
    && ln -sf /usr/bin/pip3 /usr/bin/pip \
    && microdnf clean all

# Tools installation
COPY ../../requirements.txt /tmp/
RUN pip install --no-cache-dir -r /tmp/requirements.txt \
    && curl -LO "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" \
    && unzip "terraform_${TERRAFORM_VERSION}_linux_amd64.zip" -d /usr/local/bin/ \
    && rm "terraform_${TERRAFORM_VERSION}_linux_amd64.zip" \
    && curl -LO "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/${OC_VERSION}/openshift-client-linux.tar.gz" \
    && tar xzf openshift-client-linux.tar.gz -C /usr/local/bin \
    && rm openshift-client-linux.tar.gz \
    && curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    && mv kubectl /usr/local/bin/kubectl \
    && rm -Rf /usr/local/bin/README.md \
    && microdnf remove -y tar unzip \
    && microdnf clean all

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
COPY --chown=${USER}:${USER} --chmod=755 ../../entrypoint.sh /home/${USER}/entrypoint.sh

# Switch to non-privileged user
USER ${USER}
WORKDIR /home/${USER}

# Verification of tools installed
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD terraform version && oc version --client && kubectl version --client && ansible --version || exit 1

# Default command
ENTRYPOINT ["/home/${USER}/entrypoint.sh"]
CMD ["/bin/bash"]
