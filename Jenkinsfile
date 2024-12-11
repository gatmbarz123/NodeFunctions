pipeline {
    agent {
        label 'k8s-agent'
    }
    
    tools {
        maven 'Maven'
        jdk 'JDK11'
    }
    
    environment {
        ARTIFACTORY_CREDS = credentials('artifactory-credentials')
        SONAR_TOKEN = credentials('sonarqube-token')
    }
    
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/gatmbarz123/NodeFunctions.git'
            }
        }
        
        stage('Build and Test') {
            steps {
                sh 'mvn clean test'
            }
        }
        
        stage('SonarQube Analysis') {
            agent {
                kubernetes {
                    label 'sonarqube-pod'  
                }
            }
            steps {
                container('sonarqube') {
                    withSonarQubeEnv('SonarQube') {
                        sh '''
                            sonar-scanner \
                            -Dsonar.projectKey=node-functions \
                            -Dsonar.sources=. \
                            -Dsonar.host.url=http://51.20.74.124:9000
                        '''
                    }
                }
            }
        }

        stage('Quality Gate') {
            steps {
                timeout(time: 1, unit: 'HOURS') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }
        
        stage('Deploy to Artifactory') {
            steps {
                rtMavenDeployer(
                    id: 'deployer',
                    serverId: 'artifactory-server',
                    releaseRepo: 'java-local-repo',
                    snapshotRepo: 'java-snapshot-repo'
                )
                rtMavenRun(
                    tool: 'Maven',
                    pom: 'pom.xml',
                    goals: 'clean install',
                    deployerId: 'deployer'
                )
            }
        }
        
        stage('Download from Artifactory') {
            steps {
                rtDownload(
                    serverId: 'artifactory-server',
                    spec: '''{
                        "files": [
                            {
                                "pattern": "java-snapshot-repo/com/example/node-functions/1.0-SNAPSHOT/*.jar",
                                "target": "downloaded-artifacts/"
                            }
                        ]
                    }'''
                )
                sh 'ls -l downloaded-artifacts'
            }
        }
    }
}