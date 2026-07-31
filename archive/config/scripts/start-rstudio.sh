#!/bin/bash

# Define a consistent name for your container
CONTAINER_NAME="my-rstudio-server"

# Check if a container with this name is already running
if [ "$(docker ps -q -f name=^/${CONTAINER_NAME}$)" ]; then
    echo "RStudio container is already running."
# Check if a container with this name exists but is stopped
elif [ "$(docker ps -aq -f status=exited -f name=^/${CONTAINER_NAME}$)" ]; then
    echo "Found a stopped RStudio container. Starting it..."
    docker start $CONTAINER_NAME
# Otherwise, create the new container
else
    echo "No RStudio container found. Creating a new one..."
    docker run -d \
      --name $CONTAINER_NAME \
      -p 127.0.0.1:8787:8787 \
      -v ~/Documents/rStudio:/root/ \
      -e DISABLE_AUTH=true \
      r-bayes-env
fi

sleep 2

echo "Opening RStudio in your browser..."
xdg-open http://localhost:8787