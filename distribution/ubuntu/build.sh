#!/bin/bash
docker buildx build -t bastion:0.1.0-ubuntu \
    --build-arg TERRAFORM_VERSION=1.9.8 \
    --build-arg OC_VERSION=4.17.5 \
    -f ./Dockerfile .
