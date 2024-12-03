@Library('shared') _

pipeline {
    agent any
    
    stages {
        stage('Print Node') {
            steps {
                script {
                    def nodeName = getNodeName()
                    echo "Running on node: ${nodeName}"
                }
            }
        }
    }
}