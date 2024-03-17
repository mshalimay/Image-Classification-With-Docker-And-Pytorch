#!/bin/bash

# check if there is any docker container named image-classifier, stop and remove it
if [ "$(docker ps -aq -f name=image-classifier)" ]; then
  # if there is, stop and remove it
  echo "Stopping and removing existing 'image-classifier' container ..."
  docker stop image-classifier
  docker rm image-classifier
fi

echo "Creating a new container named 'image-classifier' ..."

#------------------------------------------------------------------------------
# Solution 1: bind mount the images directory from the host machine to the container
#------------------------------------------------------------------------------
# test if the images directory exists
if [ ! -d "images" ]; then
  tar -xzf images.tar.gz
fi

# Run the container in detached mode and bind mount to the images directory
docker run -d \
  --name image-classifier \
  --mount type=bind,source=./images,target=/HW2_part1/images \
  train-model \
  tail -f /dev/null

#------------------------------------------------------------------------------
# Solution 2: create a shared volume between host machine and container
#------------------------------------------------------------------------------
# # Create volume for the images directory named shared_images
# docker volume create shared_images

# # Run the container in detached mode and mount the named volume
# docker run -d \
#   --name image-classifier \
#   -v shared_images:/HW2_part1/images \
#   train-model \
#   tail -f /dev/null

