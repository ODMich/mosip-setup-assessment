#!/bin/bash

set -e

echo "Running MOSIP Smoke Tests..."

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

echo "Testing service endpoints..."

# Test ID Authentication health
test_endpoint "ID Authentication Health" "http://$MINIKUBE_IP/idauthentication/actuator/health"

# Test Registration health  
test_endpoint "Registration Health" "http://$MINIKUBE_IP/registration/actuator/health"

# Test Prometheus
test_endpoint "Prometheus" "http://$MINIKUBE_IP:30900/graph"

echo ""
echo "Test Results: $SUCCESS/$TOTAL passed"

if [ $SUCCESS -eq $TOTAL ]; then
    echo "🎉 All smoke tests passed!"
    exit 0
else
    echo "❌ Some smoke tests failed"
    exit 1
fi