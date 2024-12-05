pipeline {
    agent any
    
    environment {
        // Replace with your Artifactory URL
        ARTIFACTORY_URL = 'http://16.16.24.80:8081/artifactory'
        // The repository you created in Artifactory
        REPO_NAME = 'NodeFunctions'
        // Name of the Jenkins credential containing your Artifactory token
        ARTIFACTORY_CREDENTIAL_ID = 'artifactory-token'
    }
    
    stages {
        stage('Generate Test File') {
            steps {
                // Create a simple text file
                sh '''
                    echo "This is a test file created by Jenkins pipeline" > test-file.txt
                    echo "Created at: $(date)" >> test-file.txt
                '''
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
                                "target": "${env.REPO_NAME}/test-files/${BUILD_NUMBER}/"
                            }
                        ]
                    }"""
                    
                    def buildInfo = server.upload spec: uploadSpec
                    server.publishBuildInfo buildInfo
                }
            }
        }
    }
}