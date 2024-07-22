#/bin/bash
set -e

export KIND_EXPERIMENTAL_PROVIDER=podman

# Get directory this script is located in to access script local files
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

# Create a deployment and service for httpbin
echo ""
echo ">> Create a deployment and service for httpbin"
kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: httpbin
  name: httpbin
  namespace: default
spec:
  replicas: 3
  selector:
    matchLabels:
      app: httpbin
  template:
    metadata:
      labels:
        app: httpbin
    spec:
      containers:
      - image: docker.io/kennethreitz/httpbin
        name: httpbin
EOF

# Create a service for httpbin
echo ""
echo ">> Create a service for httpbin"
kubectl apply -f - <<EOF
apiVersion: v1
kind: Service
metadata:
  labels:
    app: httpbin
  name: httpbin
  namespace: default
spec:
  ports:
  - port: 80
    protocol: TCP
    targetPort: 80
  selector:
    app: httpbin
  sessionAffinity: None
  type: ClusterIP
EOF

# Wait for the httpbin service to be ready
echo ""
echo ">> Wait for the httpbin service to be ready"
kubectl rollout status -n default deployment/httpbin

echo ""
echo ">> done"

