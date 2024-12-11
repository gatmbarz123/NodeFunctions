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
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh 'mvn sonar:sonar'
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
                    releaseRepo: 'libs-release-local',
                    snapshotRepo: 'libs-snapshot-local'
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
                                "pattern": "libs-release-local/com/example/demo-app/1.0-SNAPSHOT/demo-app-1.0-SNAPSHOT.jar",
                                "target": "downloaded-artifacts/"
                            }
                        ]
                    }'''
                )
            }
        }
    }
}