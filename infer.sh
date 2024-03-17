#!/bin/bash

# pick a random image to classify; loop to guarantee an image is found
while [ -z "$image_path" ]; do
    # generate a random number between 0 and 9999 and pad it with zeros
    number=$(shuf -i 0-9999 -n 1)
    padded_number=$(printf "%06d" $number)
    
    # run find command in the image-classifier container to check if the image exists
    image_path=$(docker exec image-classifier find /HW2_part1/images/ -name "${padded_number}*")
done

# execute the classifier using the random image as input
docker exec image-classifier python /HW2_part1/classify.py --input $image_path

# extract the image category from the image path and print to the terminal
number=$(echo "$image_path" | sed 's/.*num\([0-9]\+\).*/\1/')
echo "Expected: $number"