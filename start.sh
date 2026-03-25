#!/usr/bin/env bash
set -e

echo "Step 1: Generate TLS certs"
bash scripts/generate-certs.sh

echo "Step 2: Start Redis containers"
docker-compose up -d

echo "Waiting for Redis nodes to be ready..."
sleep 5

echo "Step 3: Create cluster"
bash scripts/create-cluster.sh

echo "Done."
