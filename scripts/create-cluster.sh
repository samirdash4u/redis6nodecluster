#!/usr/bin/env bash
set -e

NODES=(
  redis-1:6379
  redis-2:6379
  redis-3:6379
  redis-4:6379
  redis-5:6379
  redis-6:6379
)

CERT_DIR="./certs"

# Check if cluster already exists
echo "Checking cluster state..."

if docker exec redis-1 redis-cli \
    --tls \
    --cert /certs/redis.crt \
    --key /certs/redis.key \
    --cacert /certs/ca.crt \
    cluster info | grep -q "cluster_state:ok"; then
  echo "Cluster already initialized."
  exit 0
fi

echo "Creating Redis cluster..."

docker exec -it redis-1 redis-cli \
  --tls \
  --cert /certs/redis.crt \
  --key /certs/redis.key \
  --cacert /certs/ca.crt \
  --cluster create \
  "${NODES[@]}" \
  --cluster-replicas 1 \
  --cluster-yes

echo "Cluster created successfully."
