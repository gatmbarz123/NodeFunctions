pipeline {
    agent any
    
    environment {
        ARTIFACTORY_URL = 'http://16.16.24.80:8081/artifactory'
        // The repository you created in Artifactory
        REPO_NAME = 'NodeFunctions'
        ARTIFACTORY_CREDENTIAL_ID = 'artifactory-token'
        // Add version variables
        MAJOR_VERSION = '1'
        MINOR_VERSION = '0'
        // Full version will be 1.0.${BUILD_NUMBER}
        ARTIFACT_VERSION = "${MAJOR_VERSION}.${MINOR_VERSION}.${BUILD_NUMBER}"
    }
    
    stages {
        stage('Generate Test File') {
            steps {
                script {
                    // Create a properties file with version info
                    sh """
                        echo "version=${ARTIFACT_VERSION}" > version.properties
                        echo "This is version ${ARTIFACT_VERSION}" > test-file.txt
                        echo "Created at: \$(date)" >> test-file.txt
                    """
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
                                "pattern": "test-file.txt",
                                "target": "${env.REPO_NAME}/releases/${MAJOR_VERSION}.${MINOR_VERSION}/${ARTIFACT_VERSION}/",
                                "props": "version=${ARTIFACT_VERSION};status=release"
                            },
                            {
                                "pattern": "version.properties",
                                "target": "${env.REPO_NAME}/releases/${MAJOR_VERSION}.${MINOR_VERSION}/${ARTIFACT_VERSION}/",
                                "props": "version=${ARTIFACT_VERSION};status=release"
                            }
                        ]
                    }"""
                    
                }
            }
        }
        
        stage('Display Version Info') {
            steps {
                echo "Successfully uploaded artifact version: ${ARTIFACT_VERSION}"
                echo "Artifact location: ${REPO_NAME}/releases/${MAJOR_VERSION}.${MINOR_VERSION}/${ARTIFACT_VERSION}/"
            }
        }
    }
}