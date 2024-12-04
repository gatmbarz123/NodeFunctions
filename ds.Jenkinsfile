@Library('agent') _ 
 
pipeline {
    agent any
    stages {
        stage('Get agent info') {
            steps {
                script {
                    def agentHost = getNodeName()
                    echo "Agent hostname: ${agentHost}"
                }
            }
        }
    }
}