# Azure DevOps Setup with Jenkins, Key Vault, SQL Database, ACR & AKS

This project demonstrates how to deploy a full DevOps environment using Azure CLI, Bicep templates, and Jenkins on an Azure Virtual Machine. It covers infrastructure provisioning, Jenkins setup, and integration with Azure services like Key Vault, SQL Database, Azure Container Registry (ACR), and Azure Kubernetes Service (AKS).

---

## 📁 Pre-requisites

- `Azure Subscription Access`
- `Azure CLI`
- `Bicep CLI`
- `kubectl (Kubernetes CLI)`
- `Docker (for Jenkins builds and ACR use)`
- `Azure Key Vault`
- `SQL Server and SQL Database`
- `Azure Container Registry`
- `Azure Kubernetes Service`

---

## 📁 Project Structure

- `vnet.bicep`: Bicep template for Virtual Network
- `vm.bicep`: Bicep template for Virtual Machine
- `jenkins_install.sh`: Jenkins installation script
- `Key Vault`: To store your SQL Database credentials
- `SQL Database`: Application data storage center
- `ACR`: image repository
- `AKS`: For service deployment

---

## 🚀 Step-by-Step Deployment Guide

### ✅ Create Resource Group

```bash
az group create --name <resource-group-name> --location <location> --tags <key>=<value>
```

### ✅ Clone repo & move to modules directory

```bash
git clone https://github.com/SumanthBade/UserRegistrationApp.git
cd UserRegistrationApp/bicep/modules/
```

### ✅ Deploy Infrastructure Using Bicep
- Virtual Network

```bash
az deployment group create \
  --resource-group <resource-group-name> \
  --template-file vnet.bicep
```

- Virtual Machine (with SSH Key)

```bash
az deployment group create \
  --resource-group <resource-group-name> \
  --template-file vm.bicep \
  --parameters sshPublicKey='<your-public-key>'
```

### ✅ Connect to Virtual Machine

```bash
ssh -i OperatorVM_key.pem azureuser@<vm-ip>
```

### ✅ Update system packages & Install Azure CLI & Bicep CLI

```bash
sudo apt update
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
az bicep install
az login
```

### ✅ Install kubectl using

```bash
#!/bin/bash

# Download kubectl v1.30.0 binary
curl -LO "https://dl.k8s.io/release/v1.30.0/bin/linux/amd64/kubectl"

# Download the SHA256 checksum file for verification
curl -LO "https://dl.k8s.io/release/v1.30.0/bin/linux/amd64/kubectl.sha256"

# Verify the binary (should print nothing if correct, or 'OK' if using sha256sum -c)
	

chmod +x kubectl
sudo mv kubectl /usr/local/bin/

kubectl version --client
```

### ✅ Install Jenkins (via Script)
- Create and run jenkins_install.sh:

```bash
sudo vim jenkins_install.sh
```
- Paste the following content:

```bash
#!/bin/bash
set -e

echo "STEP-1: Installing Git, OpenJDK 17, and Maven"
sudo apt-get update
sudo apt-get install -y git openjdk-17-jdk maven wget gnupg2

java -version

echo "STEP-2: Adding Jenkins repo and importing GPG key"
sudo mkdir -p /etc/apt/keyrings
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" \
  | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

echo "STEP-3: Installing Jenkins"
sudo apt-get update
sudo apt-get install -y jenkins

echo "STEP-4: Starting Jenkins"
sudo systemctl start jenkins
sudo systemctl enable jenkins
sudo systemctl status jenkins --no-pager
```
- Make it executable and run:
```bash
chmod +x jenkins_install.sh
./jenkins_install.sh
```

### ✅ Install Docker and Git

```bash
sudo apt install docker.io -y
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
sudo apt install git -y
```

### ✅ Create Resource Group

```bash
az group create --name <resource-group-name> --location <location> --tags <key>=<value>
```

### ✅ Create Resource Group

```bash
az group create --name <resource-group-name> --location <location> --tags <key>=<value>
```

### ✅ Create Resource Group

```bash
az group create --name <resource-group-name> --location <location> --tags <key>=<value>
```






























