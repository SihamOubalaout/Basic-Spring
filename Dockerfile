# Use an official OpenJDK runtime as the base image
FROM openjdk:11-jdk-slim

# Set the working directory in the container
WORKDIR /app

# Copy the JAR file generated by Maven into the container
# Replace 'target/*.jar' with your actual JAR file name if needed
COPY target/*.jar app.jar

# Expose the port that your Spring Boot application will run on
EXPOSE 8080

# Run the Spring Boot application using the JAR file
ENTRYPOINT ["java", "-jar", "/app.jar"]