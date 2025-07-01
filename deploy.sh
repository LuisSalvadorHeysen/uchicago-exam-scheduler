#!/bin/bash

# UChicago Exam Scheduler Deployment Script
# This script helps deploy the application to various cloud platforms

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check prerequisites
check_prerequisites() {
    print_status "Checking prerequisites..."
    
    if ! command_exists docker; then
        print_error "Docker is not installed. Please install Docker first."
        exit 1
    fi
    
    if ! command_exists docker-compose; then
        print_error "Docker Compose is not installed. Please install Docker Compose first."
        exit 1
    fi
    
    print_success "Prerequisites check passed"
}

# Function to build Docker images
build_images() {
    print_status "Building Docker images..."
    
    docker build -t exam-scheduler-backend:latest ./backend
    docker build -t exam-scheduler-frontend:latest ./frontend
    
    print_success "Docker images built successfully"
}

# Function to deploy locally
deploy_local() {
    print_status "Deploying locally with Docker Compose..."
    
    docker-compose down
    docker-compose up --build -d
    
    print_success "Application deployed locally!"
    print_status "Frontend: http://localhost:3000"
    print_status "Backend: http://localhost:8080"
}

# Function to deploy to Google Cloud Platform
deploy_gcp() {
    print_status "Deploying to Google Cloud Platform..."
    
    if ! command_exists gcloud; then
        print_error "Google Cloud CLI is not installed. Please install it first."
        exit 1
    fi
    
    # Check if user is authenticated
    if ! gcloud auth list --filter=status:ACTIVE --format="value(account)" | grep -q .; then
        print_warning "You are not authenticated with Google Cloud. Please run 'gcloud auth login' first."
        exit 1
    fi
    
    # Get project ID
    PROJECT_ID=$(gcloud config get-value project 2>/dev/null)
    if [ -z "$PROJECT_ID" ]; then
        print_error "No Google Cloud project is set. Please run 'gcloud config set project YOUR_PROJECT_ID' first."
        exit 1
    fi
    
    print_status "Using project: $PROJECT_ID"
    
    # Configure Docker for GCR
    gcloud auth configure-docker
    
    # Build and push images
    docker tag exam-scheduler-backend:latest gcr.io/$PROJECT_ID/exam-scheduler-backend:latest
    docker tag exam-scheduler-frontend:latest gcr.io/$PROJECT_ID/exam-scheduler-frontend:latest
    
    docker push gcr.io/$PROJECT_ID/exam-scheduler-backend:latest
    docker push gcr.io/$PROJECT_ID/exam-scheduler-frontend:latest
    
    # Deploy to Cloud Run
    gcloud run deploy exam-scheduler-backend \
        --image gcr.io/$PROJECT_ID/exam-scheduler-backend:latest \
        --platform managed \
        --region us-central1 \
        --allow-unauthenticated \
        --port 8080
    
    gcloud run deploy exam-scheduler-frontend \
        --image gcr.io/$PROJECT_ID/exam-scheduler-frontend:latest \
        --platform managed \
        --region us-central1 \
        --allow-unauthenticated \
        --port 3000
    
    print_success "Application deployed to Google Cloud Run!"
}

# Function to deploy to AWS
deploy_aws() {
    print_status "Deploying to AWS..."
    
    if ! command_exists aws; then
        print_error "AWS CLI is not installed. Please install it first."
        exit 1
    fi
    
    # Check if AWS credentials are configured
    if ! aws sts get-caller-identity >/dev/null 2>&1; then
        print_error "AWS credentials are not configured. Please run 'aws configure' first."
        exit 1
    fi
    
    # Get AWS account ID
    ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
    REGION=$(aws configure get region)
    
    print_status "Using AWS account: $ACCOUNT_ID, region: $REGION"
    
    # Create ECR repositories if they don't exist
    aws ecr create-repository --repository-name exam-scheduler-backend --region $REGION 2>/dev/null || true
    aws ecr create-repository --repository-name exam-scheduler-frontend --region $REGION 2>/dev/null || true
    
    # Login to ECR
    aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com
    
    # Build and push images
    docker tag exam-scheduler-backend:latest $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/exam-scheduler-backend:latest
    docker tag exam-scheduler-frontend:latest $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/exam-scheduler-frontend:latest
    
    docker push $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/exam-scheduler-backend:latest
    docker push $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/exam-scheduler-frontend:latest
    
    print_success "Images pushed to ECR successfully!"
    print_warning "You'll need to create ECS services or use other AWS services to deploy the containers."
}

# Function to deploy to Azure
deploy_azure() {
    print_status "Deploying to Azure..."
    
    if ! command_exists az; then
        print_error "Azure CLI is not installed. Please install it first."
        exit 1
    fi
    
    # Check if user is logged in
    if ! az account show >/dev/null 2>&1; then
        print_error "You are not logged in to Azure. Please run 'az login' first."
        exit 1
    fi
    
    # Get subscription and resource group
    SUBSCRIPTION=$(az account show --query id --output tsv)
    RESOURCE_GROUP="exam-scheduler"
    
    print_status "Using subscription: $SUBSCRIPTION"
    
    # Create resource group if it doesn't exist
    az group create --name $RESOURCE_GROUP --location eastus 2>/dev/null || true
    
    # Create container registry if it doesn't exist
    ACR_NAME="examscheduler$(date +%s)"
    az acr create --resource-group $RESOURCE_GROUP --name $ACR_NAME --sku Basic 2>/dev/null || true
    
    # Login to ACR
    az acr login --name $ACR_NAME
    
    # Build and push images
    az acr build --registry $ACR_NAME --image exam-scheduler-backend:latest ./backend
    az acr build --registry $ACR_NAME --image exam-scheduler-frontend:latest ./frontend
    
    # Deploy to Container Instances
    az container create \
        --resource-group $RESOURCE_GROUP \
        --name exam-scheduler-backend \
        --image $ACR_NAME.azurecr.io/exam-scheduler-backend:latest \
        --dns-name-label exam-scheduler-backend \
        --ports 8080 \
        --registry-login-server $ACR_NAME.azurecr.io \
        --registry-username $(az acr credential show --name $ACR_NAME --query username --output tsv) \
        --registry-password $(az acr credential show --name $ACR_NAME --query passwords[0].value --output tsv)
    
    az container create \
        --resource-group $RESOURCE_GROUP \
        --name exam-scheduler-frontend \
        --image $ACR_NAME.azurecr.io/exam-scheduler-frontend:latest \
        --dns-name-label exam-scheduler-frontend \
        --ports 3000 \
        --registry-login-server $ACR_NAME.azurecr.io \
        --registry-username $(az acr credential show --name $ACR_NAME --query username --output tsv) \
        --registry-password $(az acr credential show --name $ACR_NAME --query passwords[0].value --output tsv)
    
    print_success "Application deployed to Azure Container Instances!"
}

# Function to deploy to Kubernetes
deploy_k8s() {
    print_status "Deploying to Kubernetes..."
    
    if ! command_exists kubectl; then
        print_error "kubectl is not installed. Please install it first."
        exit 1
    fi
    
    # Check if kubectl is configured
    if ! kubectl cluster-info >/dev/null 2>&1; then
        print_error "kubectl is not configured. Please configure it first."
        exit 1
    fi
    
    # Apply Kubernetes manifests
    kubectl apply -f k8s/
    
    print_success "Application deployed to Kubernetes!"
    print_status "Check deployment status with: kubectl get pods,services,ingress"
}

# Function to show help
show_help() {
    echo "UChicago Exam Scheduler Deployment Script"
    echo ""
    echo "Usage: $0 [OPTION]"
    echo ""
    echo "Options:"
    echo "  local      Deploy locally using Docker Compose"
    echo "  gcp        Deploy to Google Cloud Platform (Cloud Run)"
    echo "  aws        Deploy to AWS (ECR + ECS)"
    echo "  azure      Deploy to Azure (Container Instances)"
    echo "  k8s        Deploy to Kubernetes"
    echo "  build      Build Docker images only"
    echo "  help       Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 local    # Deploy locally"
    echo "  $0 gcp      # Deploy to Google Cloud"
    echo "  $0 aws      # Deploy to AWS"
}

# Main script logic
main() {
    case "${1:-help}" in
        local)
            check_prerequisites
            build_images
            deploy_local
            ;;
        gcp)
            check_prerequisites
            build_images
            deploy_gcp
            ;;
        aws)
            check_prerequisites
            build_images
            deploy_aws
            ;;
        azure)
            check_prerequisites
            build_images
            deploy_azure
            ;;
        k8s)
            check_prerequisites
            build_images
            deploy_k8s
            ;;
        build)
            check_prerequisites
            build_images
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            print_error "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
}

# Run main function with all arguments
main "$@" 