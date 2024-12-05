pipeline {
    agent {
        label 'agent-0'
    }
    
    environment {
        CI = true
        ARTIFACTORY_ACCESS_TOKEN = credentials('artifactory-access-token')
        VERSION = "1.0.${BUILD_NUMBER}"
    }
    
    stages {
        stage('Build JAR') {
            steps {
                // Maven build to create JAR
                sh 'mvn clean package -DskipTests'
            }
        }
        
        stage('Upload to Artifactory') {
            steps {
                // Using curl to upload to Artifactory
                sh """
                    curl -H "X-JFrog-Art-Api:${ARTIFACTORY_ACCESS_TOKEN}" \
                        -T target/*.jar \
                        "http://16.16.24.80:8082//artifactory/libs-release-local/com/example/myapp/${VERSION}/"
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