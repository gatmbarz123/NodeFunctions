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
                    # Create directory for Maven
                    mkdir -p /opt/maven
                    
                    # Download and extract Maven
                    cd /opt/maven
                    curl -O https://dlcdn.apache.org/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.tar.gz
                    tar xzf apache-maven-3.9.6-bin.tar.gz
                    mv apache-maven-3.9.6/* .
                    rm apache-maven-3.9.6-bin.tar.gz
                    
                    # Verify Maven installation
                    mvn --version
                '''
            }
        }
        
        stage('Build JAR') {
            steps {
                // Maven build to create JAR
                sh 'mvn clean package -DskipTests'
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