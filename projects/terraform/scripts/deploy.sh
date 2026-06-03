#!/bin/bash
set -e

echo "🚀 Deploying Image Processor Application..."

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_DIR="$( cd "$SCRIPT_DIR/.." && pwd )"

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "❌ AWS CLI is not installed. Please install it first."
    exit 1
fi

# Check if Terraform is installed
if ! command -v terraform &> /dev/null; then
    echo "❌ Terraform is not installed. Please install it first."
    exit 1
fi

# Build Lambda layer using Docker
echo "📦 Building Lambda layer with Docker..."
chmod +x "$SCRIPT_DIR/build_layer_docker.sh"
bash "$SCRIPT_DIR/build_layer_docker.sh"

# Move to Terraform project directory
echo "🔧 Initializing Terraform..."
cd "$PROJECT_DIR"

echo "📂 Current directory:"
pwd

echo "📄 Terraform files found:"
ls *.tf

# Initialize Terraform
terraform init

# Validate configuration
echo "✅ Validating Terraform configuration..."
terraform validate

# Plan deployment
echo "📋 Planning Terraform deployment..."
terraform plan -out=tfplan

# Apply deployment
echo "🚀 Applying Terraform deployment..."
terraform apply tfplan

# Get outputs
echo "📊 Getting deployment outputs..."

UPLOAD_BUCKET=$(terraform output -raw upload_bucket_name)
PROCESSED_BUCKET=$(terraform output -raw processed_bucket_name)
LAMBDA_FUNCTION=$(terraform output -raw lambda_function_name)
REGION=$(terraform output -raw region)

echo ""
echo "✅ Deployment completed successfully!"
echo ""
echo "📦 S3 Buckets:"
echo "   Upload:    s3://${UPLOAD_BUCKET}"
echo "   Processed: s3://${PROCESSED_BUCKET}"
echo ""
echo "⚡ Lambda Function:"
echo "   ${LAMBDA_FUNCTION}"
echo ""
echo "🌍 Region:"
echo "   ${REGION}"
echo ""
echo "🎯 Usage:"
echo "   aws s3 cp your-image.jpg s3://${UPLOAD_BUCKET}/"
echo ""
echo "📸 Processed images will be available in:"
echo "   s3://${PROCESSED_BUCKET}/"