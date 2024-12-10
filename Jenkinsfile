pipeline {
    agent {
        label 'sonar-agent'
    }
    
    environment {
        SONAR_URL = 'http://13.60.226.63:9000'
        ARTIFACTORY_URL = 'http://13.60.226.63:8081/artifactory'
        ARTIFACTORY_CREDS = credentials('artifactory-credentials')
        SONAR_TOKEN = credentials('sonarqube-token')
    }
    
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/gatmbarz123/NodeFunctions.git'
            }
        }
        
        stage('Install Dependencies') {
            steps {
                sh '''
                    if ! command -v npm &> /dev/null; then
                        curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
                        apt-get install -y nodejs
                    fi
                    npm install
                '''
            }
        }
        
        stage('Build') {
            steps {
                sh 'npm run build || echo "No build script found"'
            }
        }
        
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh """
                        sonar-scanner \
                            -Dsonar.projectKey=test-project \
                            -Dsonar.sources=. \
                            -Dsonar.exclusions=**/node_modules/**,**/dist/**,**/coverage/** \
                            -Dsonar.javascript.lcov.reportPaths=coverage/lcov.info \
                            -Dsonar.host.url=${SONAR_URL} \
                            -Dsonar.login=${SONAR_TOKEN}
                    """
                }
                
                timeout(time: 2, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }
        
        stage('Package') {
            steps {
                sh '''
                    tar -czf nodeFunctions.tar.gz \
                        --exclude='node_modules' \
                        --exclude='.git' \
                        --exclude='coverage' \
                        .
                '''
            }
        }
        
        stage('Upload to Artifactory') {
            steps {
                script {
                    def server = Artifactory.newServer url: ARTIFACTORY_URL, credentialsId: 'artifactory-credentials'
                    def uploadSpec = """{
                        "files": [{
                            "pattern": "nodeFunctions.tar.gz",
                            "target": "nodejs-local-repo/NodeFunctions/${BUILD_NUMBER}/",
                            "props": {
                                "build.number": "${BUILD_NUMBER}",
                                "build.name": "${JOB_NAME}"
                            }
                        }]
                    }"""
                    server.upload spec: uploadSpec
                }
            }
        }
        
        stage('Download from Artifactory') {
            steps {
                script {
                    def server = Artifactory.newServer url: ARTIFACTORY_URL, credentialsId: 'artifactory-credentials'
                    def downloadSpec = """{
                        "files": [{
                            "pattern": "nodejs-local-repo/NodeFunctions/${BUILD_NUMBER}/*.tar.gz",
                            "target": "downloaded/",
                            "flat": true
                        }]
                    }"""
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