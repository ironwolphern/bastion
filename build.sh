#!/bin/bash
# Version tools
export $(cat .env | xargs)

# Build bastion image fot python
docker buildx build -t ironwolphern/bastion-python:test \
    --build-arg TERRAFORM_VERSION=${TERRAFORM_VERSION} \
    --build-arg OC_VERSION=${OC_VERSION} \
    --build-arg GITHUB_SHA="b487c04a8e7b67f70efc5da751d9f1184cabfbc5" \
    --build-arg GITHUB_REF="refs/heads/develop" \
    --build-arg GITHUB_REPOSITORY="ironwolphern/bastion" \
    --build-arg GITHUB_ACTOR="ironwolphern" \
    -f ./distribution/python/Dockerfile .
docker builder prune -f -a

# Build bastion image for rhel
docker buildx build -t ironwolphern/bastion-rhel:test \
    --build-arg TERRAFORM_VERSION=${TERRAFORM_VERSION} \
    --build-arg OC_VERSION=${OC_VERSION} \
    --build-arg GITHUB_SHA="b487c04a8e7b67f70efc5da751d9f1184cabfbc5" \
    --build-arg GITHUB_REF="refs/heads/develop" \
    --build-arg GITHUB_REPOSITORY="ironwolphern/bastion" \
    --build-arg GITHUB_ACTOR="ironwolphern" \
    -f ./distribution/rhel/Dockerfile .
docker builder prune -f -a

# Build bastion image for ubuntu
docker buildx build -t ironwolphern/bastion-ubuntu:test \
    --build-arg TERRAFORM_VERSION=${TERRAFORM_VERSION} \
    --build-arg OC_VERSION=${OC_VERSION} \
    --build-arg GITHUB_SHA="b487c04a8e7b67f70efc5da751d9f1184cabfbc5" \
    --build-arg GITHUB_REF="refs/heads/develop" \
    --build-arg GITHUB_REPOSITORY="ironwolphern/bastion" \
    --build-arg GITHUB_ACTOR="ironwolphern" \
    -f ./distribution/ubuntu/Dockerfile .
docker builder prune -f -a
