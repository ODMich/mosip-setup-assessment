#!/bin/bash

set -e

echo "🚀 Setting up MOSIP DevOps Environment..."

# Check prerequisites
command -v minikube >/dev/null 2>&1 || { echo "Minikube required but not installed. Aborting."; exit 1; }
command -v kubectl >/dev/null 2>&1 || { echo "Kubectl required but not installed. Aborting."; exit 1; }

# Start Minikube
if ! minikube status | grep -q "Running"; then
    echo "Starting Minikube cluster..."
    minikube start --addons=ingress --cpus=4 --memory=6500 --disk-size=4g
    minikube addons enable ingress

else
    echo "Minikube is already running"
    minikube addons enable ingress
fi

# Wait for ingress controller
echo "⏳ Waiting for NGINX Ingress Controller..."
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=120s

echo "📦 Creating MOSIP namespace..."
kubectl apply -f k8s/namespace.yaml

#echo "📊 Deploying centralized logging stack (ELK)..."
#kubectl apply -f k8s/logging/

#echo "⏳ Waiting for Elasticsearch to be ready..."
#kubectl wait --for=condition=ready pod -l app=elasticsearch -n mosip --timeout=300s

echo "🚀 Deploying MOSIP services..."
kubectl apply -f k8s/ida/
kubectl apply -f k8s/regclient/
kubectl apply -f k8s/ingress.yaml

echo "📈 Deploying monitoring stack..."
kubectl apply -f k8s/monitoring/

echo "⏳ Waiting for MOSIP services to be ready..."
kubectl wait --for=condition=ready pod -l app=ida -n mosip --timeout=300s
kubectl wait --for=condition=ready pod -l app=regclient -n mosip --timeout=300s

MINIKUBE_IP=$(minikube ip)
echo ""
echo "🎉 MOSIP DevOps setup completed successfully!"
echo ""
echo "🌐 Access URLs:"
echo "   ID Authentication: http://$MINIKUBE_IP/idauthentication"
echo "   Registration: http://$MINIKUBE_IP/registration"
echo "   Monitoring:"
echo "     - Prometheus: http://$MINIKUBE_IP:30900"
echo "     - Grafana: http://$MINIKUBE_IP:30500"
#echo "   Logging:"
#echo "     - Kibana: http://$MINIKUBE_IP:30601"
echo ""
echo "🔍 Check status: kubectl get all -n mosip"
echo ""
echo "🧪 Test services: ./scripts/smoke-tests.sh"
echo "🔄 Test resilience: ./scripts/test-resilience.sh"