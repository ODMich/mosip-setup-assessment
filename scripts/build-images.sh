#!/bin/bash

set -e

echo "🔨 Building MOSIP Docker images..."

# Build ID Authentication image
echo "📦 Building ID Authentication image..."
docker build -t mosip-ida:1.2.0.1 -f docker/ida/Dockerfile .

# Build Registration Client image
echo "📦 Building Registration Client image..."
docker build -t mosip-regclient:1.2.0.1 -f docker/regclient/Dockerfile .

echo "✅ All images built successfully!"
echo ""
echo "📋 Available images:"
docker images | grep mosip