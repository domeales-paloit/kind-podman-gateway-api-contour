#/bin/bash
set -e

export KIND_EXPERIMENTAL_PROVIDER=podman

# Get directory this script is located in to access script local files
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

# Dir name
SCRIPT_DIR_BASE="$(basename "$SCRIPT_DIR")"

# The name of the kind cluster to deploy to
CLUSTER_NAME="${CLUSTER_NAME:-$SCRIPT_DIR_BASE}"
CLUSTER_NAME="${CLUSTER_NAME#"kind-"}"

DEFAULT_KIND_CONFIG_SUFFIX="-fixed-node-ports"

# K8s Gatway API version
if [ -z "$K8S_GATWAY_API_VERSION" ]; then
  K8S_GATWAY_API_VERSION=v1.0.0
fi

# Kind config suffix
if [ -z "$KIND_CONFIG_SUFFIX" ]; then
  KIND_CONFIG_SUFFIX="$DEFAULT_KIND_CONFIG_SUFFIX"
fi

cd "$SCRIPT_DIR"

# Create cluster
echo ""
echo ">> Creating cluster ${CLUSTER_NAME}"
kind create cluster \
    --name "$CLUSTER_NAME" \
    --config="kind-config$KIND_CONFIG_SUFFIX.yaml"

echo ""
echo ">> Installing Gateway API: $K8S_GATWAY_API_VERSION"
kubectl apply -f "https://github.com/kubernetes-sigs/gateway-api/releases/download/$K8S_GATWAY_API_VERSION/standard-install.yaml"

echo ""
echo ">> done"
