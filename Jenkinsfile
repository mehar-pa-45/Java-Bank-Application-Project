pipeline {
 agent any

 stages {

 stage('Checkout'){
 steps{
checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[credentialsId: 'github-cred', url: 'https://github.com/mehar-pa-45/Java-indigo-Airlines.git']])
 }
 }

 stage('Build WAR'){
 steps{
 sh 'mvn clean package'
 }
 }

 stage('Build Docker'){
 steps{
 sh 'docker build -t indigo-app .'
 }
 }

 stage('Run Container'){
 steps{
 sh 'docker run -d -p 8082:8080 indigo-app'
 }
 }

 }

}
