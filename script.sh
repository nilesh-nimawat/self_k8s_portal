#!/bin/bash

# Variables
GITHUB_REPO="https://github.com/USERNAME/REPOSITORY.git"
PROJECT_NAME="myapp"
DOCKER_USERNAME="yourdockerhubusername"
IMAGE_NAME="myapp"
TAG="latest"

echo "Cloning GitHub repository..."
git clone $GITHUB_REPO

cd $PROJECT_NAME || exit

echo "Building Docker image..."
docker build -t $DOCKER_USERNAME/$IMAGE_NAME:$TAG .



echo "Docker image pushed successfully!"