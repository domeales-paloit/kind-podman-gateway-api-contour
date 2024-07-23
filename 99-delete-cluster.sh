#/bin/bash
set -e

export KIND_EXPERIMENTAL_PROVIDER=podman

# Get directory this script is located in to access script local files
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
cd "$SCRIPT_DIR"

# Get cluster name from kind-config.yaml
CLUSTER_NAME=$(awk '/name:/{print $2}' kind-config.yaml | head -n1)

# Remove cluster
echo ""
echo ">> Removing cluster ${CLUSTER_NAME}"
kind delete cluster --name "$CLUSTER_NAME"

echo ""
echo ">> done"
