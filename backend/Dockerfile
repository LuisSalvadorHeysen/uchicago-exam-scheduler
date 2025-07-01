# Backend Dockerfile
FROM eclipse-temurin:17-jdk AS builder
WORKDIR /app

# Install dos2unix first
RUN apt-get update && apt-get install -y dos2unix

# Copy only necessary files for dependency resolution
COPY .mvn/ .mvn
COPY mvnw pom.xml ./
RUN dos2unix mvnw && chmod +x mvnw  # Fix line endings and permissions

# Build application
COPY src ./src
RUN ./mvnw clean package
