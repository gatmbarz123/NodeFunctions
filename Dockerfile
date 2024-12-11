FROM jenkins/inbound-agent:latest

USER root

# Install required packages
RUN apt-get update && \
    apt-get install -y \
    curl \
    unzip \
    maven \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Install SonarQube Scanner
ENV SONAR_SCANNER_VERSION=4.8.0.2856
ENV SONAR_SCANNER_HOME=/opt/sonar-scanner
ENV PATH $PATH:${SONAR_SCANNER_HOME}/bin

RUN curl -L https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_SCANNER_VERSION}-linux.zip -o sonar-scanner.zip \
    && unzip sonar-scanner.zip \
    && mv sonar-scanner-${SONAR_SCANNER_VERSION}-linux ${SONAR_SCANNER_HOME} \
    && rm sonar-scanner.zip \
    && chmod +x ${SONAR_SCANNER_HOME}/bin/sonar-scanner

# Create cache directory for SonarQube Scanner
RUN mkdir -p /opt/sonar-scanner/.sonar \
    && chown -R jenkins:jenkins /opt/sonar-scanner

USER jenkins