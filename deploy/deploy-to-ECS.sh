#!/bin/bash

#
# Parameters
#
TAG_VERSION=$1

#
# Variables
#
AWS_REGION="ap-southeast-1"
ECR_ENDPOINT="YOUR_ENDPOINT"
ECR_REPO_NAME="rails-json-api"

#
# Build & deploy to ECR scripts
#
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_ENDPOINT

if [ -n "$1" ]; then
  docker build -t $ECR_REPO_NAME:$TAG_VERSION .
  docker tag $ECR_REPO_NAME:$TAG_VERSION $ECR_ENDPOINT/$ECR_REPO_NAME:$TAG_VERSION
  docker tag $ECR_REPO_NAME:$TAG_VERSION $ECR_ENDPOINT/$ECR_REPO_NAME:latest

  # Push both latest & versioned container to ECR
  docker push $ECR_ENDPOINT/$ECR_REPO_NAME:$TAG_VERSION
  docker push $ECR_ENDPOINT/$ECR_REPO_NAME:latest
else
  docker build -t $ECR_REPO_NAME .
  docker tag $ECR_REPO_NAME:latest $ECR_ENDPOINT/$ECR_REPO_NAME:latest
  docker push $ECR_ENDPOINT/$ECR_REPO_NAME:latest
fi
