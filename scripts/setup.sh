#!/bin/bash

set -e

echo "Setting up MOSIP DevOps Environment..."

# Check prerequisites
command -v minikube >/dev/null 2>&1 || { echo "Minikube required but not installed. Aborting."; exit 1; }
command -v kubectl >/dev/null 2>&1 || { echo "Kubectl required but not installed. Aborting."; exit 1; }

# Start Minikube with sufficient resources
if ! minikube status | grep -q "Running"; then
    echo "Starting Minikube cluster..."
    minikube start --addons=ingress --cpus=4 --memory=5500 --disk-size=20g
else
    echo "Minikube is already running"
fi

# Enable ingress if not already enabled
minikube addons enable ingress

echo "Creating MOSIP namespace..."
kubectl apply -f k8s/namespace.yaml

echo "Creating secrets..."
kubectl create secret generic mosip-secrets \
  --namespace mosip \
  --from-literal=db-username=mosipuser \
  --from-literal=db-password=mosippassword \
  --from-literal=redis-password=redispassword \
  --from-literal=jwt-secret=myjwtsecret123 \
  --from-literal=grafana-password=admin123 \
  --dry-run=client -o yaml | kubectl apply -f -

echo "Deploying dependencies..."
kubectl apply -f k8s/postgresql.yaml
kubectl apply -f k8s/redis.yaml

echo "Waiting for dependencies to be ready..."
kubectl wait --for=condition=ready pod -l app=postgresql -n mosip --timeout=180s
kubectl wait --for=condition=ready pod -l app=redis -n mosip --timeout=180s

echo "Deploying configuration..."
kubectl apply -f k8s/configmaps/

echo "Deploying MOSIP services..."
kubectl apply -f k8s/id-auth-deployment.yaml
kubectl apply -f k8s/reg-deployment.yaml
kubectl apply -f k8s/ingress.yaml

echo "Deploying monitoring stack..."
kubectl apply -f k8s/monitoring/

echo "Waiting for MOSIP services to be ready..."
kubectl wait --for=condition=ready pod -l app=id-authentication -n mosip --timeout=300s
kubectl wait --for=condition=ready pod -l app=registration -n mosip --timeout=300s

# Get Minikube IP
MINIKUBE_IP=$(minikube ip)
echo ""
echo "MOSIP DevOps setup completed successfully!"
echo ""
echo "Access URLs:"
echo "   ID Authentication: http://$MINIKUBE_IP/idauthentication"
echo "   Registration: http://$MINIKUBE_IP/registration"
echo "   Prometheus: http://$MINIKUBE_IP:30900"
echo "   Grafana: http://$MINIKUBE_IP:30500"
echo ""
echo "Check status:"
echo "   kubectl get all -n mosip"
echo ""
echo "Run demo: ./scripts/demo-commands.sh"
echo "Test resilience: ./scripts/test-resilience.sh"