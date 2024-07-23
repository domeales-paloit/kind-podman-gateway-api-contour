#/bin/bash
set -e

export KIND_EXPERIMENTAL_PROVIDER=podman

# Get directory this script is located in to access script local files
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
cd "$SCRIPT_DIR"

# K8s Gatway API version
if [ -z "$K8S_GATWAY_API_VERSION" ]; then
  K8S_GATWAY_API_VERSION=v1.0.0
fi

# Create cluster
echo ""
echo ">> Creating cluster"
kind create cluster --config="kind-config.yaml"

echo ""
echo ">> Installing Gateway API: $K8S_GATWAY_API_VERSION"
kubectl apply -f "https://github.com/kubernetes-sigs/gateway-api/releases/download/$K8S_GATWAY_API_VERSION/standard-install.yaml"

echo ""
echo ">> done"
