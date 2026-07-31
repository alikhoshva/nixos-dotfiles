#!/bin/bash

# Define the exact same container name used in your start script
CONTAINER_NAME="my-rstudio-server"

# Check if a container with this name is actually running
if [ "$(docker ps -q -f name=^/${CONTAINER_NAME}$)" ]; then
    echo "Found running RStudio container ($CONTAINER_NAME)."
    echo "Stopping and removing it..."

    # Stop the container
    docker stop $CONTAINER_NAME

    echo "Container stopped and removed successfully."
else
    echo "No running RStudio container found with the name '$CONTAINER_NAME'."
fi