def call() {
    def podName = env.POD_NAME ?: sh(script: 'hostname', returnStdout: true).trim()
    def nodeName = sh(script: "kubectl get pod ${podName} -n \$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace) -o jsonpath='{.spec.nodeName}'", returnStdout: true).trim()
    return nodeName
}