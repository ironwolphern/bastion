#!/bin/bash
# Version tools
export $(cat .env | xargs)

# Build bastion image fot python
docker buildx build -t bastion:0.1.0-python \
    --build-arg PYTHON_VERSION=${PYTHON_VERSION}-slim \
    --build-arg TERRAFORM_VERSION=${TERRAFORM_VERSION} \
    --build-arg OC_VERSION=${OC_VERSION} \
    -f ./distribution/python/Dockerfile .
docker builder prune -f -a

# Build bastion image for rhel
docker buildx build -t bastion:0.1.0-rhel \
    --build-arg TERRAFORM_VERSION=${TERRAFORM_VERSION} \
    --build-arg OC_VERSION=${OC_VERSION} \
    -f ./distribution/rhel/Dockerfile .
docker builder prune -f -a

# Build bastion image for ubuntu
docker buildx build -t bastion:0.1.0-ubuntu \
    --build-arg TERRAFORM_VERSION=${TERRAFORM_VERSION} \
    --build-arg OC_VERSION=${OC_VERSION} \
    -f ./distribution/ubuntu/Dockerfile .
docker builder prune -f -a
