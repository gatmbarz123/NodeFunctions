pipeline {
    agent {
        label 'agent-0'  // This matches your JENKINS_AGENT_NAME
    }
    
    environment {
        CI = true
        ARTIFACTORY_ACCESS_TOKEN = credentials('artifactory-access-token')
    }
    
    stages {
        stage('Prepare Agent') {
            steps {
                // Install JFrog CLI if not present
                sh '''
                    if ! command -v jfrog &> /dev/null; then
                        curl -fL https://install-cli.jfrog.io | sh
                        mv jfrog /usr/local/bin/
                    fi
                '''
            }
        }
        
        stage('Build') {
            steps {
                // Clean and build
                sh 'mvn clean install'
            }
        }
        
        stage('Upload to Artifactory') {
            steps {
                sh """
                    jfrog rt upload \
                        --url http://16.16.24.80:8082//artifactory/ \
                        --access-token ${ARTIFACTORY_ACCESS_TOKEN} \
                        "target/*.jar" \
                        my-repo/
                """
            }
        }
    }
    
    post {
        always {
            cleanWs()
        }
    }
}