FROM ubuntu:20.04

# Set non-interactive frontend to avoid prompts during apt-get
ENV DEBIAN_FRONTEND=noninteractive

# Install prerequisites
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    git \
    openjdk-17-jdk \
    maven \
    && rm -rf /var/lib/apt/lists/*

# Clone MOSIP infra repository and install ID Authentication module
RUN git clone -b release-1.2.0.1-B2 https://github.com/mosip/mosip-infra /tmp/mosip-infra

# Navigate to IDA deployment directory and run installation
WORKDIR /tmp/mosip-infra/deployment/v3/mosip/ida

# Run installation with automated responses for development environment
RUN chmod +x install.sh && \
    printf "n\\ny\\n" | ./install.sh

# Create application directory and copy installed files
RUN mkdir -p /app/mosip-ida && \
    cp -r /tmp/mosip-infra/deployment/v3/mosip/ida/* /app/mosip-ida/ && \
    rm -rf /tmp/mosip-infra

# Set working directory
WORKDIR /app/mosip-ida

# Find and set the main JAR file
RUN JAR_FILE=$(find . -name "*.jar" | grep -v "sources.jar" | grep -v "javadoc.jar" | head -1) && \
    echo "JAR_FILE=$JAR_FILE" > /app/jar_info.txt

# Expose port
EXPOSE 8080

# Set environment variables
ENV SPRING_PROFILES_ACTIVE=development
ENV LOGGING_LEVEL_IO_MOSIP=INFO

# Start command
CMD ["/bin/bash", "-c", "JAR_FILE=$(find . -name \"*.jar\" | grep -v \"sources.jar\" | grep -v \"javadoc.jar\" | head -1) && echo \"Starting application: $JAR_FILE\" && java -jar \"$JAR_FILE\""]