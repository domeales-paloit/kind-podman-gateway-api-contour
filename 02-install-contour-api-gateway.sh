#/bin/bash
set -e

# Get directory this script is located in to access script local files
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
cd "$SCRIPT_DIR"

# Install Contour API Gateway
echo ""
echo ">> Install Contour API Gateway"
kubectl apply -f https://projectcontour.io/quickstart/contour-gateway-provisioner.yaml

# Add a GatewayClass for Contour
echo ""
echo ">> Add a GatewayClass for Contour"
kubectl apply -f - <<EOF
kind: GatewayClass
apiVersion: gateway.networking.k8s.io/v1
metadata:
  name: contour
spec:
  controllerName: projectcontour.io/gateway-controller
  parametersRef:
    group: projectcontour.io
    kind: ContourDeployment
    namespace: projectcontour
    name: contour-params
EOF

# Add a ContourDeployment to configure the Envoy network publishing to NodePort
echo ""
echo ">> Add a ContourDeployment to configure the Envoy network publishing to NodePort"
kubectl apply -f - <<EOF
kind: ContourDeployment
apiVersion: projectcontour.io/v1alpha1
metadata:
  namespace: projectcontour
  name: contour-params
spec:
  envoy:
    networkPublishing:
      type: NodePortService
EOF

# Add a Gateway to expose the HTTP port 32201
echo ""
echo ">> Add a Gateway to expose the HTTP port 32201"
kubectl apply -f - <<EOF
kind: Gateway
apiVersion: gateway.networking.k8s.io/v1
metadata:
  name: contour
  namespace: projectcontour
spec:
  gatewayClassName: contour
  listeners:
    - name: http
      protocol: HTTP
      port: 32201
      allowedRoutes:
        namespaces:
          from: All
EOF

echo ""
echo ">> done"
