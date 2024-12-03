def call() {
   def hostname = sh(script: 'hostname', returnStdout: true).trim()
   return hostname
}