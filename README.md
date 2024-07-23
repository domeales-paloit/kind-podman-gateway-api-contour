# Gateway API via Contour on Kind via Podman

This is an example of how to run the [Project Contour](https://projectcontour.io/) implementation of the [Kubernetes Gateway API](https://gateway-api.sigs.k8s.io/) on a local [Kind cluster](https://kind.sigs.k8s.io/) using [Podman](https://podman.io/) for containers.

There are more likely other ways to achieve ingress into a Kind cluster using the Gateway API, this is just the one I came up with.

## Why?

I did this as a learning exercise to understand the Gateway API but I also learnt how Kind does networking and lots about Contour.

Why Contour? To be honest I tried a number of Gateway API implementations and this is the only one I got working.

## Dependencies

The following tools are needed to run this project:
* podman ([install](https://podman.io/docs/installation))
* kind ([install](https://kind.sigs.k8s.io/docs/user/quick-start/#installation))
* kubectl ([install](https://kubernetes.io/docs/tasks/tools/#kubectl))
* curl (installation depends on OS, or you can [download](https://curl.se/download.html))

Versions used at time of authoring:
* podman 5.1.1
* kind 0.23.0
* kubectl v1.30.2
* curl 8.6.0

## Network design

For this project I selected the "Service with NodePort" networking strategy to get traffic into the Kind cluster. More information about this can be found in the repo [domeales-paloit/kind-traffic-ingress-examples](https://github.com/domeales-paloit/kind-traffic-ingress-examples).

## How to run

Inspect the contents of each Bash script and then run them in order:

1. `./01-start-cluster.sh`
1. `./02-install-contour-api-gateway.sh`
1. `./03-deploy-httpbin.sh`
1. `./04-add-route-to-httpbin.sh`


Great, you're all set up! 

Now test that you have connectivity to the httpbin Pods by running curl:

```
curl -v http://localhost:32201/get
```

And you should see the output from httpbin. There are plenty of options with httpbin, check out the docs here: [httpbin.org](https://httpbin.org/).

Congratulations, you have just deployed Gateway API on a Kind cluster via Podman.

## Clean up!
Important! When finished testing, delete the cluster

```
./99-delete-cluster.sh
```
