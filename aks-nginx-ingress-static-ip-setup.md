# AKS NGINX Ingress with Static Public IP

This repository contains steps to configure NGINX Ingress on Azure Kubernetes Service (AKS) using a reserved **static public IP**. It also includes guidance to expose applications like Jenkins via an **Ingress resource** using the static IP and [nip.io](https://nip.io/) for domain resolution without purchasing a custom domain.

---

## 🔧 Prerequisites

- Azure CLI installed and logged in
- kubectl configured with your AKS cluster
- Helm v3 installed
- A deployed AKS cluster

---

## 🚀 Steps

### ✅ Step 01: Reserve a Static Public IP in Azure

```bash
az network public-ip create \
  --resource-group <resource group of AKS> \
  --name <public-ip name> \
  --sku Standard \
  --allocation-method Static \
  --location <location>
```

## 🚀 Steps

### ✅ Step 01: Reserve a Static Public IP in Azure

```bash
az network public-ip create \
  --resource-group <resource group of AKS> \
  --name <public-ip name> \
  --sku Standard \
  --allocation-method Static \
  --location <location>
```

### ✅ Step 02: Install Helm and Add NGINX Ingress Repo

```bash
curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
```

### ✅ Step 03: Create Namespace for Ingress

```bash
kubectl create ns nginx
```

### ✅ Step 04: Install NGINX Ingress Controller with Helm

```bash
# Replace <reserved static public-ip> with the IP reserved in Step 01
helm install new-ingress-nginx ingress-nginx/ingress-nginx \
  --namespace nginx \
  --create-namespace \
  --set controller.image.tag="v1.11.5" \
  --set controller.resources.requests.cpu="25m" \
  --set controller.resources.requests.memory="150Mi" \
  --set controller.resources.limits.cpu="125m" \
  --set controller.resources.limits.memory="200Mi" \
  --set controller.replicaCount=2 \
  --set controller.service.type=LoadBalancer \
  --set controller.service.externalTrafficPolicy=Local \
  --set controller.service.loadBalancerIP="<reserved static public-ip>" \
  --set controller.ingressClass=nginx \
  --set controller.ingressClassResource.name=nginx \
  --set controller.ingressClassResource.enabled=true \
  --set controller.ingressClassResource.default=false
```

### ✅ Step 05: Verify Installation
#### Use nip.io to create a wildcard DNS entry that maps your static IP to a hostname like jenkins.<STATIC-IP>.nip.io
```bash
kubectl get pods -n nginx
kubectl get svc -n nginx
```
### ✅ Step 06: Deploy ingress resource
- Create resource using

```bash
kubectl apply -f ngress-resource.yaml
```
- Copy & Paste below code by making necessary changes
```bash
# Replace placeholders: <ingress resource name>, <namespace>, <service name>, <service port>, <static-ip>
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: <ingress resource name>
  namespace: <namespace>
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
    nginx.ingress.kubernetes.io/proxy-body-size: "1024m"
    nginx.ingress.kubernetes.io/proxy-read-timeout: "60s"
spec:
  ingressClassName: nginx
  rules:
  - host: service.<static-ip>.nip.io
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: <service name>
            port:
              number: <service port>

```

### ✅ Step 06: Apply the Ingress

```bash
kubectl apply -f ngress-resource.yaml
```

### 🌐 Access your services Without a Domain

```bash
# Browse below link by making necessary changes
service.<static-ip>.nip.io
```

## 📌 Notes
- Make sure the Kubernetes service (<service name>) is of type ClusterIP.
- You can use the same approach to expose any other service on AKS via Ingress.
