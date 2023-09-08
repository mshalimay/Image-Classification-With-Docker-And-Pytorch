#!/bin/bash

# Define the Dockerfile contents
DOCKERFILE=$(cat <<EOF
# syntax=docker/dockerfile:1

FROM python:3

WORKDIR /HW2_part1

COPY train.py classify.py ./

# COPY images.tar.gz ./ # uncomment this if using shared volume
# RUN tar -xzf images.tar.gz # uncomment this if using shared volume

RUN pip install --no-cache-dir tensorflow imageio

RUN python train.py
EOF
)

# Write the Dockerfile to the current directory
echo "$DOCKERFILE" > Dockerfile

echo "Dockerfile created. Now building the image..."

# Build the image
docker build -t train-model .

