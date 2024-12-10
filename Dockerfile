FROM jenkins/inbound-agent:latest

USER root

# Install Python and required tools
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Install SonarQube Scanner
RUN wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.8.0.2856-linux.zip \
    && unzip sonar-scanner-cli-4.8.0.2856-linux.zip \
    && mv sonar-scanner-4.8.0.2856-linux /opt/sonar-scanner \
    && rm sonar-scanner-cli-4.8.0.2856-linux.zip

# Add SonarQube Scanner to PATH
ENV PATH="/opt/sonar-scanner/bin:${PATH}"

# Switch back to jenkins user
USER jenkins