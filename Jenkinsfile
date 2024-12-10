pipeline {
    agent {
        label 'sonar-agent'
    }
    
    environment {
        SONAR_URL = 'http://13.60.226.63:9000'
        ARTIFACTORY_URL = 'http://13.60.226.63:8082'
        ARTIFACTORY_CREDS = credentials('artifactory-credentials')
    }
    
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/your-repo/your-project.git'
            }
        }
        
        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }
        
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh """
                        sonar-scanner \
                            -Dsonar.projectKey=your-project \
                            -Dsonar.sources=src/main/java \
                            -Dsonar.java.binaries=target/classes \
                            -Dsonar.host.url=${SONAR_URL}
                    """
                }
                
                timeout(time: 2, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }
        
        stage('Upload to Artifactory') {
            steps {
                script {
                    def server = Artifactory.server 'artifactory'
                    def uploadSpec = """{
                        "files": [{
                            "pattern": "target/*.jar",
                            "target": "java-local-repo/"
                        }]
                    }"""
                    server.upload(uploadSpec)
                }
            }
        }
        
        stage('Download from Artifactory') {
            steps {
                script {
                    def server = Artifactory.server 'artifactory'
                    def downloadSpec = """{
                        "files": [{
                            "pattern": "java-local-repo/*.jar",
                            "target": "downloaded/"
                        }]
                    }"""
                    server.download(downloadSpec)
                }
            }
        }
    }
}