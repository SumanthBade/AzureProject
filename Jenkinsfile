pipeline {
    agent any

    tools {
        dockerTool 'docker' // Make sure this matches Jenkins Global Tool Configuration
    }

    // environment {
    //     IMAGE_TAG = "${BUILD_NUMBER}"
    //     DEPLOYMENT_YAML = "k8s/deployment.yaml" // Change path as per your repo structure
    //     SERVICE_NAME = "userregistrationapp"
    //     ACR_URL = "youracr.azurecr.io"
    //     ACR_IMAGE = "${ACR_URL}/${SERVICE_NAME}:${IMAGE_TAG}"
    //     ACR_USERNAME = credentials('ACRUSERNAME') // Jenkins Credentials ID
    //     ACR_PASSWORD = credentials('ACRPASSWD')   // Jenkins Credentials ID
    //     AKS_RG = "your-aks-resource-group"
    //     AKS_CLUSTER = "your-aks-cluster"
    // }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/SumanthBade/UserRegistrationApp.git'
            }
        }

        stage('Check files') {
            steps {
                sh 'pwd'
                sh 'ls -al'
            }
        }

        stage('Approval: Build & Push') {
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    input message: "Approve Docker Build & Push to ACR?"
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh '''
                    cd /var/lib/jenkins/workspace/UserRegistrationPipeline
                    sudo docker build -t userapp .
                    '''
                    sh "cd /var/lib/jenkins/workspace/UserRegistrationPipeline"
                    sh "sed -i 's/ENVIRONMENT-BUILD_NUMBER/${IMAGE_TAG}/' ${DEPLOYMENT_YAML}"
                    sh "docker image build -t ${ACR_IMAGE} ."
                }
            }
        }

        stage('Push Docker Image to ACR') {
            steps {
                sh 'echo "$ACR_PASSWORD" | docker login -u "$ACR_USERNAME" --password-stdin ${ACR_URL}'
                sh "docker push ${ACR_IMAGE}"
            }
        }

        stage('Approval: Deploy to AKS') {
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    input message: "Approve deployment to AKS?"
                }
            }
        }

        stage('Deploy to AKS') {
            steps {
                script {
                    sh """
                        az login --identity
                        az aks get-credentials --resource-group ${AKS_RG} --name ${AKS_CLUSTER} --overwrite-existing
                        kubectl apply -f ${DEPLOYMENT_YAML}
                        sleep 30
                        kubectl rollout status deployment/${SERVICE_NAME}
                    """
                }
            }
        }

        stage('Cleanup') {
            steps {
                sh 'docker system prune --all --volumes -f'
                cleanWs()
            }
        }
    }

    post {
        success {
            echo '✅ Deployment completed successfully!'
        }
        failure {
            echo '❌ Deployment failed. Please check the logs.'
        }
        always {
            script {
                echo "📦 Pipeline finished at: ${new Date()}"
            }
        }
    }
}
