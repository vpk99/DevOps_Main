#!/bin/bash
set -e

echo "🚀 Building Lambda Layer with Pillow using Docker..."

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_DIR="$( cd "$SCRIPT_DIR/.." && pwd )"

# Your Terraform files (main.tf, variables.tf, etc.) are here
TERRAFORM_DIR="$PROJECT_DIR"

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    exit 1
fi

# Check if Docker is running
if ! docker info &> /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker first."
    exit 1
fi

echo "📦 Building layer in Linux container (Python 3.12)..."

echo "SCRIPT_DIR=$SCRIPT_DIR"
echo "PROJECT_DIR=$PROJECT_DIR"
echo "TERRAFORM_DIR=$TERRAFORM_DIR"

# Disable Git Bash path conversion
MSYS_NO_PATHCONV=1 docker run --rm \
  --platform linux/amd64 \
  -v "$TERRAFORM_DIR:/output" \
  python:3.12-slim \
  bash -c "
    echo '📦 Installing Pillow for Linux AMD64...' && \
    mkdir -p /tmp/python/lib/python3.12/site-packages && \
    pip install --quiet Pillow==10.4.0 -t /tmp/python/lib/python3.12/site-packages/ && \
    cd /tmp && \
    echo '📦 Creating layer zip file...' && \
    apt-get update -qq && \
    apt-get install -y -qq zip > /dev/null 2>&1 && \
    zip -q -r pillow_layer.zip python/ && \
    cp pillow_layer.zip /output/ && \
    echo '✅ Layer built successfully!'
  "

echo ""
echo "📍 Layer Location: $TERRAFORM_DIR/pillow_layer.zip"
echo "✅ Lambda layer is now compatible with AWS Lambda!"