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
                // Specify the branch 'master'
                git branch: 'master', url: 'https://github.com/SihamOubalaout/Basic-Spring.git'
            }
        }

        stage('Build') {
            steps {
                // Run Maven build to create the JAR file for Spring Boot app
                bat 'mvn clean package -DskipTests'  // Build the application and skip tests for faster builds
            }
        }

        stage('Build and Run Services') {
            steps {
                script {
                    // Check if the container already exists
                    def containerExists = bat(returnStatus: true, script: 'docker ps -a -q -f name=jee-app-tomcat')
                    if (containerExists == 0) {
                        echo "Container 'jee-app-tomcat' already exists, skipping creation."
                    } else {
                        echo "Creating and running the 'jee-app-tomcat' container."
                        bat 'docker-compose up -d --build'  // Build and run MySQL and app containers
                    }
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                script {
                    def scannerHome = tool 'SonarScanner'
                    withSonarQubeEnv('SonarQube') {
                        bat """
                        ${scannerHome}\\bin\\sonar-scanner.bat ^
                        -Dsonar.projectKey=SpringBootJPAApp ^
                        -Dsonar.host.url=https://01a0-154-144-237-193.ngrok-free.app ^
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

        stage('Teardown') {
            steps {
                script {
                    bat 'docker-compose down'  // Stop and remove containers
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Check if Docker image exists
                    def imageExists = bat(returnStatus: true, script: 'docker images -q jee-app-tomcat')
                    if (imageExists == 0) {
                        echo "Docker image 'jee-app-tomcat' already exists, skipping build."
                    } else {
                        echo "Building Docker image 'jee-app-tomcat'."
                        // Build Docker image for the Spring Boot app
                        docker.build('jee-app-tomcat', '.')
                    }
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                script {
                    // Check if the container is running
                    def containerRunning = bat(returnStatus: true, script: 'docker ps -q -f name=jee-app-tomcat')
                    if (containerRunning == 0) {
                        echo "Container 'jee-app-tomcat' already running."
                    } else {
                        echo "Running Docker container 'jee-app-tomcat'."
                        docker.image('jee-app-tomcat').run('-p 9091:9090')
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    // Assign the custom URL for Spring Boot application
                    def customUrl = "http://localhost:8081/PainCare/acceuil.jsp"
                    echo "Deployment complete. Application should be running at ${customUrl}"
                }
            }
        }
    }

    post {
        always {
            // Clean up the workspace after build
            cleanWs()
        }
    }
}
