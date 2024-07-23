# Gateway API via Contour on Kind via Podman

This is an example of how to run the [Project Contour](https://projectcontour.io/) implementation of the [Kubernetes Gateway API](https://gateway-api.sigs.k8s.io/) on a local [Kind cluster](https://kind.sigs.k8s.io/) using [Podman](https://podman.io/) for containers.

There are more likely other ways to achieve ingress into a Kind cluster using the Gateway API, this is just the one I came up with.

## Why?

I did this as a learning exercise to understand the Gateway API but I also learnt how Kind does networking and lots about Contour.

## Dependencies

The following tools are needed to run this project:
* podman ([install](https://podman.io/docs/installation))
* kind ([install](https://kind.sigs.k8s.io/docs/user/quick-start/#installation))
* kubectl ([install](https://kubernetes.io/docs/tasks/tools/#kubectl))
* curl (installation depends on OS, or you can [download](https://curl.se/download.html))

## Networking design

To help discuss the network design, this document uses these terms:

* *Host* - The machine running the Kind cluster
* *Node container* - A Podman container running on the *Host* that is a `Node` for the Kind cluster
* *Pod container* - A containerd container running on the *Node container* (DinD style) which is a Kubernetes container, attached to a `Pod`

### Getting traffic into Kind clusters

Since each `Node` in our Kind cluster is a Podman container there is an additional networking interface to configure to get traffic into the cluster: that is the *Host* <==> *Node container* network interface.

There are multiple ways to get traffic through this interface to the correct pods, but they all include the use of the Kind config parameter `extraPortMappings` ([doc](https://kind.sigs.k8s.io/docs/user/configuration/#extra-port-mappings)). This parameter allows adding port mappings between the *Host* and the *Node container* (ie. node) in question.

### Getting traffic from `Node`to `Pod`

Once the traffic is in the *Node container*, it needs to arrive at the *Pod container* in question.

There are at least two ways to do this (there may be more):
1. Using the `hostPort` parameter of a `ports` entry for the container of a `Pod`
1. Using a `Service` object with the type `NodePort`

#### Using `hostPort` on `Pod`

This is the method described in the [Kind docs](https://kind.sigs.k8s.io/docs/user/ingress/) to get the Ingress Nginx controller working for Kind.

Using the `hostPort` ([doc](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-v1/#ports)) parameter on a `Pod` spec is one way to get the traffic from the *Host* to the *Pod container*. To ensure this works correctly we need to make sure that the `Pod` (ie. *Pod container*) is running on the `Node` (ie. *Node container*) that has the `extraPortMappings` (see above).

```yaml
#
# kind-config.yaml
#
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  kubeadmConfigPatches:
  - |
    kind: InitConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        node-labels: "extra-port-8082=true"
  extraPortMappings:
  - protocol: TCP
    # The container port is the port that will be available on the
    # "Node container" (Podman container) for the "Pod container"
    # (containerd container)
    containerPort: 8082
    # The hostPort in this configuration is the port on the "Host"
    # (where Kind is running). This is the port we can access from our
    # localhost to get traffic to the "Pod container"
    hostPort: 8081
```

and

```yaml
#
# Nginx server pod
#
apiVersion: v1
kind: Pod
metadata:
  name: get-traffic-from-host
spec:
  containers:
  - name: nginx
    image: nginx
    imagePullPolicy: IfNotPresent
    # Adding a nodeSelector that matchs the "node-labels" from the Kind
    # config ensures that the Pod container is created on the Node that
    # has the `extraPortMappings`
    nodeSelector:
      extra-port-8082: true
    ports:
    - containerPort: 80
      # Here we had the upstream port, but remember in our case the "Host"
      # here is a "Node container" (Podman) so we are using the value 8082
      hostPort: 8082
      name: http
      protocol: TCP
```


#### Using `Service` with type `NodePort`

todo
