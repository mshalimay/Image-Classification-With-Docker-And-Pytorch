# syntax=docker/dockerfile:1

FROM python:3

WORKDIR /HW2_part1

COPY train.py classify.py ./

# COPY images.tar.gz ./ # uncomment this if using shared volume
# RUN tar -xzf images.tar.gz # uncomment this if using shared volume

RUN pip install --no-cache-dir tensorflow imageio

RUN python train.py
