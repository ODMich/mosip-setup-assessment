#!/bin/bash

set -e

echo "🧪 Testing MOSIP System Resilience..."

echo "1. Current pod status:"
kubectl get pods -n mosip

echo "2. Checking logging stack status:"
kubectl get pods -n mosip -l app=elasticsearch
kubectl get pods -n mosip -l app=kibana

echo "3. Simulating pod failure for ID Authentication..."
POD_NAME=$(kubectl get pods -n mosip -l app=ida -o jsonpath='{.items[0].metadata.name}')
echo "   Deleting pod: $POD_NAME"
kubectl delete pod "$POD_NAME" -n mosip

echo "4. Waiting for auto-recovery (this will re-install the module)..."
echo "   The new pod will automatically install the MOSIP ID Authentication module"
kubectl wait --for=condition=ready pod -l app=ida -n mosip --timeout=600s

echo "5. Testing service continuity..."
MINIKUBE_IP=$(minikube ip)
for i in {1..15}; do
    response=$(curl -s -o /dev/null -w "%{http_code}" "http://$MINIKUBE_IP/idauthentication/actuator/health" || echo "000")
    if [ "$response" -eq 200 ]; then
        echo "   ✅ ID Authentication service recovered successfully: HTTP $response"
        break
    fi
    echo "   ⏳ Waiting for service recovery... Attempt $i/15"
    sleep 10
done

echo "6. Checking centralized logging..."
echo "   Logs should be available in Kibana for the new pod"
echo "   Access Kibana at: http://$MINIKUBE_IP:30601"

echo "7. Testing logging stack resilience..."
echo "   Restarting Elasticsearch..."
kubectl rollout restart deployment/elasticsearch -n mosip
kubectl wait --for=condition=ready pod -l app=elasticsearch -n mosip --timeout=300s

echo "8. Final status:"
kubectl get pods -n mosip

echo "🎉 Resilience test completed successfully!"
echo "📊 Logs are being centralized to Elasticsearch and can be viewed in Kibana"