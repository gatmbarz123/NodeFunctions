pipeline {
    agent { label 'agent' }
    stages {
        stage('Get agent info') {
            steps {
                script {
                    def agentHost = getAgentInfo()
                    echo "Agent hostname: ${agentHost}"
                }
            }
        }
    }
}