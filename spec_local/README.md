# Local Cluster of Stack

1. start up minikube
2. ensure that cluser ip (`minikube ip`) points to `slotlocal.com`
    - add registry in /etc/hosts
    - this is the domain that GOOGLE SSO will redirect to
3. enable ingress: `minikube addons enable ingress`
4. run startup.sh

> As a placeholder, 'slot' was used as the namespace/image name (for registries)
