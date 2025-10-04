#!/bin/bash

echo "Testing MOSIP System Resilience..."

echo "1. Current pod status:"
kubectl get pods -n mosip

echo "2. Simulating pod failure for ID Authentication..."
POD_NAME=$(kubectl get pods -n mosip -l app=id-authentication -o jsonpath='{.items[0].metadata.name}')
echo "   Deleting pod: $POD_NAME"
kubectl delete pod "$POD_NAME" -n mosip

echo "3. Waiting for auto-recovery..."
kubectl wait --for=condition=ready pod -l app=id-authentication -n mosip --timeout=180s

echo "4. Testing service continuity..."
MINIKUBE_IP=$(minikube ip)ss
for i in {1..10}; do
    response=$(curl -s -o /dev/null -w "%{http_code}" "http://$MINIKUBE_IP/idauthentication/actuator/health" || echo "000")
    if [ "$response" -eq 200 ]; then
        echo "   ✅ Service recovered successfully: HTTP $response"
        break
    fi
    echo "   ⏳ Waiting for service recovery... Attempt $i/10"
    sleep 10
done

echo "5. Testing rolling update..."
echo "   Updating ID Authentication image..."
kubectl set image deployment/id-authentication id-authentication=mosipid/mosip-id-authentication-service:1.2.4 -n mosip
kubectl rollout status deployment/id-authentication -n mosip --timeout=300s

echo "6. Testing rollback..."
kubectl rollout undo deployment/id-authentication -n mosip
kubectl rollout status deployment/id-authentication -n mosip --timeout=180s

echo "7. Final status:"
kubectl get pods -n mosip

echo "🎉 Resilience test completed successfully!"