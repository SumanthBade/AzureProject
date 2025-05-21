pipeline {
    agent any
    tools {
        dockerTool 'docker'
    }

    parameters {
        choice(
            choices: ['dev', 'test', 'uat', 'prod'],
            description: 'Select the target environment',
            name: 'ENV'
        )
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
                sed -i "s|repo_imagetag|userreg${ENV}:${ENV}-${BUILD_NUMBER}|" user_registration_deployment.yaml
                '''
            }
        }
        stage('Approval: Push to ACR & Deploy to AKS') {
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    input message: "Approve Docker Build & Push to ACR?"
                }
            }
        }
        stage('Push the Docker Image to ACR') {
            steps {
                sh '''
                docker image push userregacr.azurecr.io/userreg"${ENV}":${ENV}-${BUILD_NUMBER}
                '''
            }
        }
        stage('Deploy_to_AKS') {
            steps {
                sh '''
                az login --identity
                az aks get-credentials --resource-group RG-AzureProject-dev --name UserRegistrationAKSCluster-dev --overwrite-existing
                kubectl apply -f user_registration_deployment.yaml
                '''
            }
        }
        stage("Removing the Docker Images and Cache") {
            steps {
                sh 'docker system prune --all --volumes -f'
                cleanWs()
            }
        }
    }
}
