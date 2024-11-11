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
                // Specify the branch and repository for the Spring Boot app
                git branch: 'main', url: 'https://github.com/SihamOubalaout/Basic-Spring.git'
            }
        }

        stage('Build') {
            steps {
                // Build the Spring Boot application using Maven (skip tests for faster builds)
                bat 'mvn clean package -DskipTests'
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
                        -Dsonar.host.url=https://11dc-154-144-237-193.ngrok-free.app ^
                        -Dsonar.login=sqp_723375720a1c928bb81609b6f070c12e5622aaf3 ^
                        -Dsonar.sources=src ^
                        -Dsonar.exclusions="**/node_modules/**" ^
                        -Dsonar.java.binaries=target/classes
                        """
                    }
                }
            }
        }

        stage('Quality Gate') {
            steps {
                timeout(time: 30, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Check if Docker image exists
                    def imageExists = bat(returnStatus: true, script: 'docker images -q spring-boot-app')
                    if (imageExists == 0) {
                        echo "Docker image 'spring-boot-app' already exists, skipping build."
                    } else {
                        echo "Building Docker image 'spring-boot-app'."
                        // Build the Docker image for Spring Boot application
                        docker.build('spring-boot-app', '.')
                    }
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                script {
                    // Run the Docker container for Spring Boot app
                    echo "Running Docker container 'spring-boot-app'."
                    docker.image('spring-boot-app').run('-p 8080:8080')
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    // Assign the custom URL for Spring Boot application
                    def customUrl = "http://localhost:8000"
                    echo "Deployment complete. Application should be running at ${customUrl}"
                }
            }
        }

        stage('Teardown') {
            steps {
                script {
                    // Stop and remove Docker containers
                    bat 'docker-compose down'
                }
            }
        }
    }

    post {
        always {
            // Clean up the workspace after the build is complete
            cleanWs()
        }
    }
}
