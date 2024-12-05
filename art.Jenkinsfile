pipeline {
    agent {
        label 'agent-0'
    }
    
    environment {
        CI = true
        ARTIFACTORY_ACCESS_TOKEN = credentials('artifactory-access-token')
        VERSION = "1.0.${BUILD_NUMBER}"
        MAVEN_HOME = "/opt/maven"
        PATH = "${MAVEN_HOME}/bin:${env.PATH}"
    }
    
    stages {
        stage('Setup Maven') {
            steps {
                sh '''
                    # Create directory for Maven in user's home
                    mkdir -p ${HOME}/maven
                    
                    # Download and extract Maven
                    cd ${HOME}/maven
                    curl -O https://dlcdn.apache.org/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.tar.gz
                    tar xzf apache-maven-3.9.6-bin.tar.gz
                    mv apache-maven-3.9.6/* .
                    rm apache-maven-3.9.6-bin.tar.gz
                    rm -rf apache-maven-3.9.6
                    
                    # Add execute permissions
                    chmod +x ${HOME}/maven/bin/mvn
                    
                    # Print Maven version to verify installation
                    ${HOME}/maven/bin/mvn --version
                '''
            }
        }
        
        stage('Build JAR') {
            steps {
                sh '''
                    # Use Maven from our installation
                    ${HOME}/maven/bin/mvn clean package -DskipTests
                '''
            }
        }
        
        stage('Upload to Artifactory') {
            steps {
                // Using curl to upload to Artifactory
                sh """
                    curl -H "X-JFrog-Art-Api:${ARTIFACTORY_ACCESS_TOKEN}" \
                        -T target/*.jar \
                        "http://16.16.24.80:8082//artifactory/libs-release-local/com/example/myapp/${VERSION}/"
                """
            }
        }
    }
    
    post {
        always {
            cleanWs()
        }
    }
}