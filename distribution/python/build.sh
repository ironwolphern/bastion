#!/bin/bash
docker buildx build -t bastion:0.1.0-python \
    --build-arg PYTHON_VERSION=3.13.0-slim \
    --build-arg TERRAFORM_VERSION=1.9.8 \
    --build-arg OC_VERSION=4.17.5 \
    -f ./Dockerfile .
