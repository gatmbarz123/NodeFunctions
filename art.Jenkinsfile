pipeline {
    agent any
    
    environment {
        CI = true
        ARTIFACTORY_ACCESS_TOKEN = credentials('artifactory-access-token')
    }
    
    stages {
        stage('Build') {
            steps {
                // Clean and install
                sh './mvnw clean install'
            }
        }
        
        stage('Upload to Artifactory') {
            agent {
                docker {
                    image 'releases-docker.jfrog.io/jfrog/jfrog-cli-v2:2.2.0'
                    reuseMode true
                }
            }
            steps {
                sh 'jfrog rt upload --url http://16.16.24.80:8082//artifactory/ --access-token ${ARTIFACTORY_ACCESS_TOKEN}'
            }
        }
    }
}