pipeline {
    agent any
    tools {
        dockerTool 'docker'
    }
    environment {
        acrusername = credentials('acrusername')  // Give secret name that you put in your keyvault
        acrpassword = credentials('acrpassword')
    }
    stages {
        stage('Code_Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/SumanthBade/UserRegistrationApp.git'
            }
        }
        stage('Docker_build') {
            steps {
                sh '''
                echo "$acrpassword" | docker login -u "$acrusername" --password-stdin userregacr.azurecr.io
                docker image build --network=host -t userregacr.azurecr.io/userreg"${ENV}":${ENV}-${BUILD_NUMBER} .
                '''
            }
        }
        stage('Push the Docker Image to ACR Hub') {
            steps {
                sh '''
                docker image push userregacr.azurecr.io/userreg"${ENV}":${ENV}-${BUILD_NUMBER}
                '''
            }
        }
        stage('Approval: Build & Push') {
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    input message: "Approve Docker Build & Push to ACR?"
                }
            }
        }
        stage('Deploy_to_AKS') {
            steps {
                sh '''
                az login --identity
                az aks get-credentials --resource-group RG-AzureProject-dev --name UserRegistrationAKSCluster-dev --overwrite-existing
                kubectl get no
                '''
            }
        }
    }
}
