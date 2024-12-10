pipeline {
    agent {
        dockerfile {
            filename 'Dockerfile'
            args '-v $HOME/.m2:/home/jenkins/.m2'
        }
    }
    
    environment {
        ARTIFACTORY_URL = 'http://artifactory.example.com/artifactory'
        ARTIFACTORY_REPO = 'python-local'
        ARTIFACTORY_CREDS = credentials('artifactory-credentials')
        SONAR_URL = 'http://sonarqube.example.com'
        SONAR_TOKEN = credentials('sonarqube-token')
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Install Dependencies') {
            steps {
                sh 'pip3 install -r requirements.txt'
            }
        }
        
        stage('Run Tests') {
            steps {
                sh 'python3 -m pytest test_app.py --cov=. --cov-report=xml'
            }
        }
        
        stage('SonarQube Analysis') {
            steps {
                sh """
                    sonar-scanner \
                    -Dsonar.projectKey=python-sample \
                    -Dsonar.sources=. \
                    -Dsonar.host.url=${SONAR_URL} \
                    -Dsonar.login=${SONAR_TOKEN} \
                    -Dsonar.python.coverage.reportPaths=coverage.xml \
                    -Dsonar.exclusions=test_*.py
                """
            }
        }
        
        stage('Package Application') {
            steps {
                sh 'zip -r app.zip app.py requirements.txt'
            }
        }
        
        stage('Upload to Artifactory') {
            steps {
                script {
                    def uploadSpec = """{
                        "files": [{
                            "pattern": "app.zip",
                            "target": "${ARTIFACTORY_REPO}/python-app/${BUILD_NUMBER}/app.zip"
                        }]
                    }"""
                    
                    def server = Artifactory.newServer url: env.ARTIFACTORY_URL, 
                                                    credentialsId: 'artifactory-credentials'
                    
                    def buildInfo = server.upload spec: uploadSpec
                    server.publishBuildInfo buildInfo
                }
            }
        }
        
        stage('Download from Artifactory') {
            steps {
                script {
                    def downloadSpec = """{
                        "files": [{
                            "pattern": "${ARTIFACTORY_REPO}/python-app/${BUILD_NUMBER}/app.zip",
                            "target": "downloaded_app.zip"
                        }]
                    }"""
                    
                    def server = Artifactory.newServer url: env.ARTIFACTORY_URL, 
                                                    credentialsId: 'artifactory-credentials'
                    
                    server.download spec: downloadSpec
                }
            }
        }
    }
    
    post {
        always {
            cleanWs()
        }
    }
}