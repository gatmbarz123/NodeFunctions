def call() {
   def hostname = sh(script: 'hostname', returnStdout: true)
   return hostname
}