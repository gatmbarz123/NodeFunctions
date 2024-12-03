@Library('shared') _

pipeline {
    agent any
    stages {
        stage('Print Node') {
            steps {
                script {
                    echo "Running on node: ${getNodeName()}"
                }
            }
        }
    }
}