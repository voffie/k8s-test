#!/bin/bash

APP_VERSION="1.0-SNAPSHOT"

docker build -t k8s-test:$APP_VERSION .

echo "Applying prometheus"
kubectl apply -f k8s/prometheus

echo "Applying loki"
kubectl apply -f k8s/loki

echo "Deploying app using Helm"
helm upgrade --install k8s-test ./k8s-test --set image.tag=$APP_VERSION

echo "Applying promtail"
kubectl apply -f k8s/promtail

echo "Applying grafana"
kubectl apply -f k8s/grafana
