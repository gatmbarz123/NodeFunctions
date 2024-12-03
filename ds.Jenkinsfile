@Library('hostname_agent') _ 
 
pipeline {
    agent { label 'agent' }
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