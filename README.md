# Bastion Docker Image

![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=flat&logo=docker&logoColor=white)
![GitHub License](https://img.shields.io/github/license/ironwolphern/bastion)
![GitHub release (with filter)](https://img.shields.io/github/v/release/ironwolphern/bastion)
![GitHub pull requests](https://img.shields.io/github/issues-pr/ironwolphern/bastion)
![GitHub closed pull requests](https://img.shields.io/github/issues-pr-closed/ironwolphern/bastion)
![GitHub issues](https://img.shields.io/github/issues/ironwolphern/bastion)
[![Docker Images Validation](https://github.com/ironwolphern/bastion/actions/workflows/check_images.yml/badge.svg)](https://github.com/ironwolphern/bastion/actions/workflows/check_images.yml)
[![Trivy](https://github.com/ironwolphern/bastion/actions/workflows/trivy.yml/badge.svg)](https://github.com/ironwolphern/bastion/actions/workflows/trivy.yml)
![Dependabot](https://badgen.net/github/dependabot/ironwolphern/bastion)

## Overview

This Docker image provides a containerized environment for running any devops tools how terraform, ansible, oc, kubectl, python and more. It is built on top of three base images (python, ubi9-minimal, ubuntu) and includes this tools:

- Terraform
- Ansible
- Openshift CLI
- Kubernetes CLI
- Python
- Git
- Curl
- jq
- sshpass

## Quick Start

```bash
# Pull the Python distribution image
docker pull ghcr.io/ironwolphern/bastion-python:latest

# Run the Python distribution container
docker run -d \
  --name my-container \
  -v $(pwd):/home/devops \
  -v ~/.ssh:/home/devops/.ssh:ro \
  -v ~/.kube:/home/devops/.kube:ro \
  -v ~/.ansible:/home/devops/.ansible:ro \
  -v ~/.terraform.d:/home/devops/.terraform.d:ro \
  ghcr.io/ironwolphern/bastion-python:latest

# Pull the Redhat distribution image
docker pull ghcr.io/ironwolphern/bastion-rhel:latest

# Run the Redhat distribution container
docker run -d \
  --name my-container \
  -v $(pwd):/home/devops \
  -v ~/.ssh:/home/devops/.ssh:ro \
  -v ~/.kube:/home/devops/.kube:ro \
  -v ~/.ansible:/home/devops/.ansible:ro \
  -v ~/.terraform.d:/home/devops/.terraform.d:ro \
  ghcr.io/ironwolphern/bastion-rhel:latest

# Pull the Ubuntu distribution image
docker pull ghcr.io/ironwolphern/bastion-ubuntu:latest

# Run the Ubuntu distribution container
docker run -d \
  --name my-container \
  -v $(pwd):/home/devops \
  -v ~/.ssh:/home/devops/.ssh:ro \
  -v ~/.kube:/home/devops/.kube:ro \
  -v ~/.ansible:/home/devops/.ansible:ro \
  -v ~/.terraform.d:/home/devops/.terraform.d:ro \
  ghcr.io/ironwolphern/bastion-ubuntu:latest
```

An example of using the container tools from outside of the container

Edit your .bashrc or .bash_profile

```bash:
# ~/.bashrc or ~/.bash_profile
alias bastion-run='docker run --rm -it \
  -v $(pwd):/home/devops \
  -v ~/.ssh:/home/devops/.ssh:ro \
  -v ~/.kube:/home/devops/.kube:ro \
  -v ~/.ansible:/home/devops/.ansible:ro \
  -v ~/.terraform.d:/home/devops/.terraform.d:ro \
  ghcr.io/ironwolphern/bastion-python:latest'

alias ansible-playbook='bastion-run ansible-playbook'
alias terraform='bastion-run terraform'
alias oc='bastion-run oc'
alias kubectl='bastion-run kubectl'
```

## Available Tags

- `latest`: Most recent stable release
- `1.0.0`: Specific version release
- `develop`: Development version (unstable)

## Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `TERRAFORM_VERSION` | Terraform cli version | `1.10.1` |
| `OC_VERSION` | Openshift cli version | `4.17.6` |
| `UID` | UID to the user and group | `10001` |
| `USER` | Username | `devops` |

## Volumes

The image uses the following optional volumes:

- `/home/devops/.ssh`: ssh keys
- `/home/devops/.kube`: Kubernetes configuration files
- `/home/devops/.ansible`: Ansible configuration files
- `/home/devops/.terraform.d`: Terraform configuration files

## Building the Image

```bash
# Clone the repository
git clone https://github.com/ironwolphern/bastion.git
cd bastion

# Build the images
./build.sh
```

## Docker Compose

Here's an example `docker-compose.yml`:

```yaml
services:
  app:
    image: ghcr.io/ironwolphern/bastion-python:latest
    restart: unless-stopped
    volumes:
      - $(pwd):/home/devops
      - ~/.ssh:/home/devops/.ssh:ro
      - ~/.kube:/home/devops/.kube:ro
      - ~/.ansible:/home/devops/.ansible:ro
      - ~/.terraform.d:/home/devops/.terraform.d:ro
    networks:
      - Secure

networks:
  Secure:
    external: true
    driver: bridge
```

## Health Check

The image includes a health check that verifies the application is running correctly:

```dockerfile
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD terraform version && oc version --client && kubectl version --client && ansible --version || exit 1
```

## Security

- The container runs as a non-root user
- All unnecessary packages and files are removed
- Security updates are regularly applied
- Sensitive data should be passed via environment variables or secrets

## Roadmap

Add more tools

## License

This project is licensed under the MIT License.

## Author

This docker image was created in 2024 by:

- Fernando Hernández San Felipe (ironwolphern@outlook.com)

