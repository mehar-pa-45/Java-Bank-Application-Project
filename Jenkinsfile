pipeline {
    agent any

    environment {

        GIT_REPO   = "https://github.com/mehar-pa-45/Java-Bank-Application-Project.git"
        GIT_BRANCH = "main"

        DOCKERHUB_USER = "mehardocker45" 
        IMAGE_NAME     = "java-bank-application-project"
        IMAGE_TAG      = "latest"   

        DOCKER_CREDS   = "Docker_CRED" 
        K8S_DEPLOYMENT = "bank-deployment" 
        K8S_NAMESPACE  = "default"
    }

    stages {

        stage('Checkout Code') {
            steps {
                checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[credentialsId: 'Github-Cred', url: 'https://github.com/mehar-pa-45/Java-Bank-Application-Project.git']])

            }
        }

        stage('Build Docker Image') {
            steps {
                sh """
                docker build -t ${DOCKERHUB_USER}/${IMAGE_NAME}:${IMAGE_TAG} .
                """
            }
        }

        stage('DockerHub Login') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: "${DOCKER_CREDS}",
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {

                    sh """
                    echo \$DOCKER_PASS | docker login -u \$DOCKER_USER --password-stdin
                    """
                }
            }
        }

        stage('Push Image to DockerHub') {
            steps {
                sh """
                docker push ${DOCKERHUB_USER}/${IMAGE_NAME}:${IMAGE_TAG}
                """
            }
        }

        stage('Deploy to Kubernetes') {
    steps {
        withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')]) {
            sh '''
            export KUBECONFIG=$KUBECONFIG

            kubectl set image deployment/bank-deployment \
            bank-deployment=mehardocker45/java-bank-application-project:latest

            kubectl rollout restart deployment bank-deployment
            '''
            }
         }
       }
    }
}
