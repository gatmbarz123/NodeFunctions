def call() {
    def podName = sh(script: 'hostname', returnStdout: true).trim()
    def nodeName = sh(script: """
        kubectl get pod ${podName} -o jsonpath='{.spec.nodeName}'
    """, returnStdout: true).trim()
    return nodeName
}