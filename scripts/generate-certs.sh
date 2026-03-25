#!/usr/bin/env bash
set -e

CERT_DIR="./certs"
mkdir -p ${CERT_DIR}

if [ -f "${CERT_DIR}/ca.crt" ]; then
  echo "TLS certs already exist. Skipping generation."
  exit 0
fi

echo "Generating TLS certificates..."

# CA
openssl genrsa -out ${CERT_DIR}/ca.key 4096
openssl req -x509 -new -nodes -key ${CERT_DIR}/ca.key \
  -sha256 -days 3650 -subj "/CN=redis-ca" \
  -out ${CERT_DIR}/ca.crt

# Server cert
openssl genrsa -out ${CERT_DIR}/redis.key 2048
openssl req -new -key ${CERT_DIR}/redis.key \
  -subj "/CN=redis" -out ${CERT_DIR}/redis.csr

openssl x509 -req -in ${CERT_DIR}/redis.csr \
  -CA ${CERT_DIR}/ca.crt -CAkey ${CERT_DIR}/ca.key \
  -CAcreateserial -out ${CERT_DIR}/redis.crt \
  -days 3650 -sha256

# Permissions
chmod 600 ${CERT_DIR}/*.key

echo "TLS certificates generated."
