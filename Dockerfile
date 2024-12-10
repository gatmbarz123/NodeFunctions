FROM jenkins/inbound-agent:latest

USER root

# Install SonarQube Scanner
RUN curl -L https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.8.0.2856-linux.zip -o sonar-scanner.zip \
    && unzip sonar-scanner.zip \
    && mv sonar-scanner-4.8.0.2856-linux /opt/sonar-scanner \
    && rm sonar-scanner.zip

ENV PATH $PATH:/opt/sonar-scanner/bin

# Install Java and Maven
RUN apt-get update && apt-get install -y maven

USER jenkins