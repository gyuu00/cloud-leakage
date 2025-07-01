#!/bin/bash
set -e

REPO="lambda-leakage"
REGION="ap-northeast-2"
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
IMAGE_URI="$ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$REPO:latest"

# ECR 리포지터리 존재 여부 확인 및 생성
if ! aws ecr describe-repositories --repository-names "$REPO" --region "$REGION" >/dev/null 2>&1; then
  echo "🆕 ECR 리포지터리 생성 중: $REPO"
  aws ecr create-repository --repository-name "$REPO" --region "$REGION"
fi

# Docker 빌드
echo "🐳 Docker 이미지 빌드 중..."
docker build -t "$REPO" .

# 태그 및 로그인
docker tag "$REPO:latest" "$IMAGE_URI"
aws ecr get-login-password --region "$REGION" \
  | docker login --username AWS --password-stdin "$ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com"

# Docker 이미지 푸시
echo "🚀 Docker 이미지 푸시 중..."
docker push "$IMAGE_URI"

echo "✅ Lambda에 사용할 수 있는 ECR 이미지가 준비되었습니다:"
echo "$IMAGE_URI"
