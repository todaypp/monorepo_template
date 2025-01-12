#!/bin/sh

kubectl config view >>spec_local/config

export CLUSTER_INGRESS_IP=""
export DOMAIN="slotlocal.com"
export MONGODB_URI="mongodb"
export MONGODB_DB="localSlot"
export GOOGLE_CLIENT_ID="ENTER_CLIENT_ID"
export GOOGLE_CLIENT_SECRET="ENTER_CLIENT_SECRET"

while [ -z $CLUSTER_INGRESS_IP ]; do
  echo "Waiting for minikube end point..."
  CLUSTER_INGRESS_IP=$(minikube ip)
  [ -z "$CLUSTER_INGRESS_IP" ] && sleep 10
done

echo "End point ready-" && echo "$CLUSTER_INGRESS_IP"

# bazel run //spec_local:controllers.apply;
#linkerd check;
bazel run //spec_local:ns_slot.apply
bazel run //spec_local:k8s_1.apply --define=CLUSTER_INGRESS_IP="$CLUSTER_INGRESS_IP" --define=MONGODB_URI=$MONGODB_URI --define=MONGODB_DB=$MONGODB_DB --define=GOOGLE_CLIENT_ID=$GOOGLE_CLIENT_ID --define=GOOGLE_CLIENT_SECRET=$GOOGLE_CLIENT_SECRET --define=DOMAIN=$DOMAIN
bazel run //spec_local:k8s_2.apply --define=CLUSTER_INGRESS_IP="$CLUSTER_INGRESS_IP" --define=MONGODB_URI=$MONGODB_URI --define=MONGODB_DB=$MONGODB_DB --define=GOOGLE_CLIENT_ID=$GOOGLE_CLIENT_ID --define=GOOGLE_CLIENT_SECRET=$GOOGLE_CLIENT_SECRET --define=DOMAIN=$DOMAIN
bazel run //spec_local:nodejs_deployment.apply --platforms=@build_bazel_rules_nodejs//toolchains/node:linux_amd64 --define=DOMAIN=$DOMAIN
