#!/bin/bash

APP_VERSION="1.0-SNAPSHOT"

docker build -t k8s-test:$APP_VERSION .

echo "Applying ArgoCD"
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo "Waiting for ArgoCD to start"
kubectl wait --namespace argocd \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/name=argocd-server \
  --timeout=120s

echo "Applying ArgoCD applications"
kubectl apply -f k8s/argocd

echo "Applying prometheus"
kubectl apply -f k8s/prometheus

echo "Applying loki"
kubectl apply -f k8s/loki

echo "Applying promtail"
kubectl apply -f k8s/promtail

echo "Applying grafana"
kubectl apply -f k8s/grafana

ARGOCD_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" | base64 -d)

echo "ArgoCD UI available at https://localhost:8080"
echo "Username: admin"
echo "Password: $ARGOCD_PASSWORD"

kubectl port-forward svc/argocd-server -n argocd 8080:443