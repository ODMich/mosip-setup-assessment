#!/bin/bash

set -e

echo "🚀 Running MOSIP Smoke Tests..."

MINIKUBE_IP=$(minikube ip)
SUCCESS=0
TOTAL=0

test_endpoint() {
    local name=$1
    local url=$2
    local expected_code=${3:-200}
    
    ((TOTAL++))
    echo -n "Testing $name... "
    
    response=$(curl -s -o /dev/null -w "%{http_code}" "$url" || echo "000")
    
    if [ "$response" -eq "$expected_code" ]; then
        echo "✅ HTTP $response"
        ((SUCCESS++))
    else
        echo "❌ HTTP $response (expected $expected_code)"
    fi
}

echo "📋 Testing service endpoints..."

# Test ID Authentication
test_endpoint "ID Authentication Health" "http://$MINIKUBE_IP/idauthentication/actuator/health"
test_endpoint "ID Authentication Info" "http://$MINIKUBE_IP/idauthentication/actuator/info"

# Test Registration
test_endpoint "Registration Health" "http://$MINIKUBE_IP/registration/actuator/health"
test_endpoint "Registration Info" "http://$MINIKUBE_IP/registration/actuator/info"

# Test Monitoring
test_endpoint "Prometheus" "http://$MINIKUBE_IP:30900/graph" 200
test_endpoint "Grafana" "http://$MINIKUBE_IP:30500" 200

# Test Logging
test_endpoint "Kibana" "http://$MINIKUBE_IP:30601" 200
test_endpoint "Elasticsearch" "http://$MINIKUBE_IP:30601/api/status" 200

# Test Prometheus metrics
test_endpoint "IDA Metrics" "http://$MINIKUBE_IP/idauthentication/actuator/prometheus" 200
test_endpoint "Registration Metrics" "http://$MINIKUBE_IP/registration/actuator/prometheus" 200

echo ""
echo "📊 Checking pod status..."
kubectl get pods -n mosip

echo ""
echo "📊 Checking logging stack..."
kubectl get pods -n mosip -l app=kibana
kubectl get pods -n mosip -l app=elasticsearch
kubectl get pods -n mosip -l app=filebeat

echo ""
echo "📊 Test Results: $SUCCESS/$TOTAL passed"

if [ $SUCCESS -eq $TOTAL ]; then
    echo "🎉 All smoke tests passed!"
    exit 0
else
    echo "❌ Some smoke tests failed"
    exit 1
fi