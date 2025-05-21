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
