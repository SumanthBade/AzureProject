# 🌐 Azure DevOps Solution: Infra Provisioning, App Deployment & Monitoring

## 📌 Objective

To implement a comprehensive solution in **Microsoft Azure** that encompasses:
- Infrastructure provisioning
- Application deployment
- End-to-end monitoring and observability

---

## 🛠️ Scope of Work

### 1. Infrastructure Provisioning

Automated provisioning of the following Azure resources using **Bicep templates**:
- **Virtual Network (VNet)**: For secure and isolated networking.
- **Virtual Machines (VMs)**: For compute workloads and bastion access if required.
- **Azure SQL Database**: For persisting application data securely.
- **Azure Kubernetes Service (AKS)**: For container orchestration and scalable application hosting.

---

### 2. Application Deployment

- A **sample application** will be built and deployed using **Jenkins** into the AKS cluster.
- Jenkins CI/CD pipeline handles:
  - Code checkout
  - Docker image build & push
  - Helm/Kubectl deployment to AKS

---

### 3. Monitoring and Observability

A full-stack monitoring solution will be integrated into the environment using:
- **Prometheus**: For metrics collection
- **Grafana**: For visualization and dashboards
- **Loki**: For log aggregation and querying

These tools help track performance, availability, and operational metrics for both the application and infrastructure.

---

## 📦 Application Behavior

- The deployed web application provides a simple UI for users to:
  - Enter personal details (username and password)
  - Submit the form
- Submitted data is securely stored in the **Azure SQL Database**
- Security best practices (e.g., encryption in transit and at rest) will be applied to protect sensitive information

---

## 🚀 Tools & Technologies

| Category        | Technology        |
|----------------|-------------------|
| IaC            | Bicep             |
| CI/CD          | Jenkins           |
| Container Orchestration | Azure Kubernetes Service (AKS) |
| Database       | Azure SQL Database |
| Monitoring     | Prometheus, Grafana, Loki |
| Scripting      | Azure CLI, Shell (Git Bash) |

---

## 🔗 Prerequisites

- Azure Subscription
- Azure CLI
- Bicep CLI
- Git Bash / PowerShell
- Jenkins Server
- Docker Installed (for image build)

---

## 📄 License

This project is for educational and demonstration purposes. Adapt accordingly for production use.

---

# 🚀 Azure Bicep Setup Guide

This repository provides a guide to set up your local environment for working with Azure Bicep templates.

---

## ✅ Pre-requisites

Ensure the following are installed on your machine before proceeding:

- [Visual Studio Code (VS Code)](https://code.visualstudio.com/)
- [Git Bash](https://git-scm.com/downloads)
- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-windows?tabs=azure-cli&pivots=msi)
- Bicep Extension for VS Code

---

## 🧾 Setup Instructions

### Step 01: Install Azure CLI and Git Bash

- **Azure CLI**:  
  Download and install the [Azure CLI - Microsoft Installer (64-bit)](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-windows?tabs=azure-cli&pivots=msi)

- **Git Bash**:  
  Download and install Git Bash from [here](https://git-scm.com/downloads)

---

### Step 02: Install Bicep Extension in VS Code

1. Open **Visual Studio Code**
2. Go to the **Extensions** tab (or press `Ctrl+Shift+X`)
3. Search for **"Bicep"** and install the extension published by Microsoft

---

### Step 03: Login to Azure

Open **Git Bash** or your terminal and run:

```bash
az login
```

---

### Step 04: Install Bicep CLI using Azure CLI

Open **Git Bash** or your terminal and run:

```bash
az bicep install
```

---

### Step 05: Check the installed version of Bicep

Open **Git Bash** or your terminal and run:

```bash
az bicep version
```

---

### Step 06: Create resource group

Open **Git Bash** or your terminal and run:

```bash
az group create --name RG-AzureProject --location eastus --tags projectType=AzureProject environment=dev
```

**OUTPUT:**

```bash
{
  "id": "/subscriptions/db75716a-bc0d-4d76-872c-0c6179241fc3/resourceGroups/RG-AzureProject",
  "location": "eastus",
  "managedBy": null,
  "name": "RG-AzureProject",
  "properties": {
    "provisioningState": "Succeeded"
  },
  "tags": {
    "environment": "dev",
    "projectType": "AzureProject"
  },
  "type": "Microsoft.Resources/resourceGroups"
}
```
