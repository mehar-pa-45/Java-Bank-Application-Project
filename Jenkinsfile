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
                checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[credentialsId: 'Github-Cred', url: "${GIT_REPO}"]])
            }
            post {
                success {
                    emailext subject: "Checkout Success: ${env.JOB_NAME}",
                             body: "Checkout stage completed successfully.\nBuild URL: ${env.BUILD_URL}",
                             to: "prsam.789@gmail.com"
                }
                failure {
                    emailext subject: "Checkout Failed: ${env.JOB_NAME}",
                             body: "Checkout stage failed.\nCheck logs: ${env.BUILD_URL}",
                             to: "prsam.789@gmail.com"
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${DOCKERHUB_USER}/${IMAGE_NAME}:${IMAGE_TAG} ."
            }
            post {
                success {
                    emailext subject: "Build Success: ${env.JOB_NAME}",
                             body: "Docker image built successfully.\nBuild URL: ${env.BUILD_URL}",
                             to: "prsam.789@gmail.com"
                }
                failure {
                    emailext subject: "Build Failed: ${env.JOB_NAME}",
                             body: "Docker build failed.\nCheck logs: ${env.BUILD_URL}",
                             to: "prsam.789@gmail.com"
                }
            }
        }

        stage('DockerHub Login') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: "${DOCKER_CREDS}",
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh "echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin"
                }
            }
            post {
                success {
                    emailext subject: "DockerHub Login Success: ${env.JOB_NAME}",
                             body: "Login to DockerHub succeeded.",
                             to: "prsam.789@gmail.com"
                }
                failure {
                    emailext subject: "DockerHub Login Failed: ${env.JOB_NAME}",
                             body: "Login to DockerHub failed.",
                             to: "prsam.789@gmail.com"
                }
            }
        }

        stage('Push Image to DockerHub') {
            steps {
                sh "docker push ${DOCKERHUB_USER}/${IMAGE_NAME}:${IMAGE_TAG}"
            }
            post {
                success {
                    emailext subject: "Push Success: ${env.JOB_NAME}",
                             body: "Image pushed successfully to DockerHub.",
                             to: "prsam.789@gmail.com"
                }
                failure {
                    emailext subject: "Push Failed: ${env.JOB_NAME}",
                             body: "Image push failed.\nCheck logs: ${env.BUILD_URL}",
                             to: "prsam.789@gmail.com"
                }
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
            post {
                success {
                    emailext subject: "Deploy Success: ${env.JOB_NAME}",
                             body: "Deployment updated successfully in Kubernetes.",
                             to: "prsam.789@gmail.com"
                }
                failure {
                    emailext subject: "Deploy Failed: ${env.JOB_NAME}",
                             body: "Deployment failed.\nCheck logs: ${env.BUILD_URL}",
                             to: "prsam.789@gmail.com"
                }
            }
        }
    }
}
