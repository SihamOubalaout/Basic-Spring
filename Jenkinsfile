
pipeline {
    agent any
 environment {
        // Ensure Docker and Maven paths are properly set
        PATH = "C:\\WINDOWS\\SYSTEM32;C:\\Program Files\\Docker\\Docker\\resources\\bin"
    }
     tools {
        maven 'Maven' // Ensure Maven is installed in Jenkins
    }
    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/SihamOubalaout/Basic-Spring.git', branch: 'main'
            }
        }

        stage('Compile') {
            steps {
                // Assurez-vous que Maven est installé et configuré dans Jenkins
                bat 'mvn clean compile'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                script {
                    def scannerHome = tool 'SonarScanner'
                    withSonarQubeEnv('SonarQube') {
                        bat """
                            ${scannerHome}\\bin\\sonar-scanner.bat ^
                            -Dsonar.projectKey=spring ^
                           -Dsonar.host.url=https://6e48-105-73-96-62.ngrok-free.app ^
                           -Dsonar.login=sqp_9fac781ea4ea647945de8ac837695631933c2a1a ^
                            -Dsonar.sources=./src ^
                            -Dsonar.java.binaries=./target/classes
                        """
                    }
                }
            }
        }

        stage('Quality Gate') {
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }
    }
}


