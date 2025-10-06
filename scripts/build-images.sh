#!/bin/bash

set -e

echo "🔨 Building MOSIP Docker images..."

echo "📦 Building ID Authentication image..."
docker build -t mosip-ida:latest -f docker/ida/Dockerfile .

echo "📦 Building Registration Client image..."
docker build -t mosip-regclient:latest -f docker/regclient/Dockerfile .

echo "✅ All images built successfully!"
echo ""
echo "📋 Available images:"
docker images | grep mosip