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
        stage('Approval_for_Build, Push & Deploy_to_AKS') {
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    input message: "Approve Docker Build, Push to ACR & Deploy to ACR?"
                }
            }
        }
        stage('Build_image') {
            steps {
                sh '''
                echo "$acrpassword" | docker login -u "$acrusername" --password-stdin userregacr.azurecr.io
                docker image build --network=host -t userregacr.azurecr.io/userreg"${ENV}":${ENV}-${BUILD_NUMBER} .
                sed -i "s|repo_imagetag|userreg${ENV}:${ENV}-${BUILD_NUMBER}|" user_registration_deployment.yaml
                '''
            }
        }
        stage('Push_Image_to_ACR') {
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
        stage("Prune_images") {
            steps {
                sh 'docker system prune --all --volumes -f'
                cleanWs()
            }
        }
    }
}
