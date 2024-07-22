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

cd "$SCRIPT_DIR"

# Remove cluster
echo ""
echo ">> Removing cluster ${CLUSTER_NAME}"
podman ps \
  | grep "$CLUSTER_NAME" \
  | awk '{print $1}' \
  | xargs -n1 podman rm -f

echo ""
echo ">> done"
