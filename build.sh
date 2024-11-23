#!/bin/bash
# Version tools
PYTHON=3.13.0
TERRAFORM=1.9.8
OC=4.17.5

# Build bastion image fot python
docker buildx build -t bastion:0.1.0-python \
    --build-arg PYTHON_VERSION=${PYTHON}-slim \
    --build-arg TERRAFORM_VERSION=${TERRAFORM} \
    --build-arg OC_VERSION=${OC} \
    -f ./distribution/python/Dockerfile .
docker builder prune -f -a

# Build bastion image for rhel
docker buildx build -t bastion:0.1.0-rhel \
    --build-arg TERRAFORM_VERSION=${TERRAFORM} \
    --build-arg OC_VERSION=${OC} \
    -f ./distribution/rhel/Dockerfile .
docker builder prune -f -a

# Build bastion image for ubuntu
docker buildx build -t bastion:0.1.0-ubuntu \
    --build-arg TERRAFORM_VERSION=${TERRAFORM} \
    --build-arg OC_VERSION=${OC} \
    -f ./distribution/ubuntu/Dockerfile .
docker builder prune -f -a
