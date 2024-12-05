pipeline {
    agent any
    
    tools {
        maven 'Maven'
        jdk 'JDK11'
    }
    
    environment {
        ARTIFACTORY_URL = 'http://16.16.24.80:8081/artifactory'
        REPO_NAME = 'NodeFunctions'
        ARTIFACTORY_CREDENTIAL_ID = 'artifactory-token'
        
        MAJOR_VERSION = '1'
        MINOR_VERSION = '0'
        ARTIFACT_VERSION = "${MAJOR_VERSION}.${MINOR_VERSION}.${BUILD_NUMBER}"
    }
    
    stages {
        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }
        
        stage('Test') {
            steps {
                sh 'mvn test'
            }
            post {
                always {
                    junit '**/target/surefire-reports/*.xml'
                }
            }
        }
        
        stage('Upload to Artifactory') {
            steps {
                script {
                    def server = Artifactory.newServer url: env.ARTIFACTORY_URL, credentialsId: env.ARTIFACTORY_CREDENTIAL_ID
                    
                    def uploadSpec = """{
                        "files": [
                            {
                                "pattern": "target/simple-java-app-*.jar",
                                "target": "${env.REPO_NAME}/java-releases/${MAJOR_VERSION}.${MINOR_VERSION}/${ARTIFACT_VERSION}/",
                                "props": "version=${ARTIFACT_VERSION};status=release;type=jar"
                            }
                        ]
                    }"""
                    
                    def buildInfo = server.upload spec: uploadSpec
                    buildInfo.env.collect()
                    server.publishBuildInfo buildInfo
                }
            }
        }
        
        stage('Display Version Info') {
            steps {
                echo "Successfully uploaded JAR version: ${ARTIFACT_VERSION}"
                echo "Artifact location: ${REPO_NAME}/java-releases/${MAJOR_VERSION}.${MINOR_VERSION}/${ARTIFACT_VERSION}/"
            }
        }
    }
}