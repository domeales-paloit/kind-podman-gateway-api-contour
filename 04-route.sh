#/bin/bash
set -e

export KIND_EXPERIMENTAL_PROVIDER=podman

# Get directory this script is located in to access script local files
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

# Add a HTTPRoute to route traffic to the httpbin service
echo ""
echo ">> Add a HTTPRoute to route traffic to the httpbin service"
kubectl apply -f - <<EOF
apiVersion: gateway.networking.k8s.io/v1beta1
kind: HTTPRoute
metadata:
  name: httpbin
  namespace: default
spec:
  parentRefs:
  - name: contour
    namespace: projectcontour
  rules:
  - backendRefs:
    - name: httpbin
      port: 80
    filters:    
    - type: ResponseHeaderModifier
      responseHeaderModifier:
        add:
        - name: X-Header-Add-1
          value: header-add-1
        - name: X-Header-Add-2
          value: header-add-2
        - name: X-Header-Add-3
          value: header-add-3
    - type: RequestHeaderModifier
      requestHeaderModifier:
        add:
        - name: my-header-name
          value: my-header-value
        remove:
        - X-Envoy-Internal
EOF

echo ""
echo ">> done"

echo ""
echo "Please test the following curl command to see if the httpbin service is reachable:"
echo "curl -v http://localhost:33301/get"

