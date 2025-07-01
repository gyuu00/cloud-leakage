#!/bin/bash
set -e

ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
REGION="ap-northeast-2"
REPO="lambda-leakage"

# ECR repo 생성
aws ecr describe-repositories --repository-names $REPO 2>/dev/null || \
  aws ecr create-repository --repository-name $REPO

# Docker 빌드 및 푸시
docker build -t $REPO .
docker tag $REPO:latest $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$REPO:latest
aws ecr get-login-password --region $REGION \
  | docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com
docker push $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$REPO:latest

echo "✅ 이미지 푸시 완료: $REPO"
