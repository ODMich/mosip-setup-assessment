#!/bin/bash

echo "🔄 Rollback commands..."

echo "1. Rolling back ID Authentication:"
kubectl rollout undo deployment/ida -n mosip
kubectl rollout status deployment/ida -n mosip --timeout=180s

echo "2. Rolling back Registration Client:"
kubectl rollout undo deployment/regclient -n mosip
kubectl rollout status deployment/regclient -n mosip --timeout=180s

echo "3. Checking rollback status:"
kubectl get deployments -n mosip -o wide

echo "✅ Rollback completed"