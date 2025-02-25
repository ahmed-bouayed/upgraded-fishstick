---
title: Kubernetes cluster monitoring
description: Deploy Prometheus and Grafana on Kubernetes using Helm
published: true
date: 2025-02-25
categories: Kubernetes
tags: k8s monitoring kubernetes devops
image:
  path: /assets/img/headers/mon-k8s.webp
  lqip: data:image/webp;base64,UklGRmoAAABXRUJQVlA4IF4AAAAwAwCdASoUAAsAPpE6l0eloyIhMAgAsBIJZQAAW+V4VXrgAP762dYR2BWQL0+TP8gRxyryQVs5dHYeIqBOElBuq1BSdWTi9AA24+3bYz+rQkzpxBXsefs1zf4PAAAA
  alt: Prometheus and Grafana
---

## Prerequisites
- Kubernetes 1.19+
- Helm 3+

## install kubectl

Download the latest release with the command

```shell
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
```

Install kubectl

```shell
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
```

check kubectl is installed

```shell
kubectl version --client
```

## install helm

```shell
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
```

## Deploy stack

1. Get Helm Repository Info
```shell
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
```
2. To create a namespace, run the following command
```shell
kubectl create namespace monitoring
```
3. Install the `kube-prometheus-stack` chart
```shell
helm install -n monitoring prometheus-stack prometheus-community/kube-prometheus-stack
```
This installs:
- Prometheus Operator
- Prometheus
- Alertmanager
- Grafana (with pre-configured dashboards)
- Node Exporter, Kube State Metrics, etc.
4. kube-prometheus-stack has been installed. Check its status by running
```shell
kubectl --namespace monitoring get pods -l "release=prometheus-stack"
```
OR
```shell
kubectl get svc -n monitoring
```
5. Get Grafana 'admin' user password by running
```shell
kubectl --namespace monitoring get secrets prometheus-stack-grafana -o jsonpath="{.data.admin-password}" | base64 -d ; echo
```
6. Access Grafana local instance
```shell
export POD_NAME=$(kubectl --namespace monitoring get pod -l "app.kubernetes.io/name=grafana,app.kubernetes.io/instance=prometheus-stack" -oname)
```
The above command will export a shell variable named POD_NAME that will save the complete name of the pod which got deployed.
7. Run the following port forwarding command to direct the Grafana pod to listen to port 3000
```shell
kubectl --namespace monitoring port-forward $POD_NAME 3000
```

<!--
```shell
kubectl --namespace monitoring port-forward $POD_NAME 3000 --address='0.0.0.0'
```
-->

Visit <https://github.com/prometheus-operator/kube-prometheus> for instructions on how to create & configure Alertmanager and Prometheus instances using the Operator.

## Access to Dashboard

1. Navigate to `localhost:3000` in your browser.
2. The Grafana sign-in page appears.
3. To sign in, enter `admin` for the username.
4. For the password paste it which you have saved it earlier.

## Uninstall (if needed)
```sh
helm uninstall prometheus-stack -n monitoring
kubectl delete namespace monitoring
```
## Next Steps

- Customize monitoring with `values.yaml`
- Integrate external alerting (Slack, Email)
- Enable persistent storage for long-term data retention