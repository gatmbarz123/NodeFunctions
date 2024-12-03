def call() {
    def nodeName = sh(script: 'hostname', returnStdout: true).trim()
    return nodeName
}