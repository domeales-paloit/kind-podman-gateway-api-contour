# Gateway API via Contour on Kind via Podman

This is an example of how to run the [Project Contour](https://projectcontour.io/) implementation of the [Kubernetes Gateway API](https://gateway-api.sigs.k8s.io/) on a local [Kind cluster](https://kind.sigs.k8s.io/) using [Podman](https://podman.io/) for containers.

There are more likely other ways to achieve ingress into a Kind cluster using the Gateway API, this is just the one I came up with.

## Why bother

I did this as a learning exercise to understand the Gateway API but I also learnt how Kind does networking and lots about Contour.

## Dependencies

The following tools are needed to run this project:
* podman ([install](https://podman.io/docs/installation))
* kind ([install](https://kind.sigs.k8s.io/docs/user/quick-start/#installation))
* kubectl ([install](https://kubernetes.io/docs/tasks/tools/#kubectl))
* curl (installation depends on OS, or you can [download](https://curl.se/download.html))

## ...

more to come