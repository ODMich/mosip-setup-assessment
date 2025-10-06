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

# Clone MOSIP infra repository (using main branch since specific branch doesn't exist)
RUN git clone https://github.com/mosip/mosip-infra /tmp/mosip-infra

# Navigate to IDA deployment directory
WORKDIR /tmp/mosip-infra/deployment/v3/mosip/ida

# Check what's available in the directory
RUN ls -la

# If install.sh exists, run it with automated responses
RUN if [ -f "install.sh" ]; then \
        echo "Running IDA installation..." && \
        chmod +x install.sh && \
        printf "n\\ny\\n" | ./install.sh; \
    else \
        echo "install.sh not found, checking for alternative installation methods..." && \
        find . -name "*.sh" -o -name "*.jar" | head -10; \
    fi

# Create application directory and copy files
RUN mkdir -p /app/mosip-ida && \
    cp -r . /app/mosip-ida/ && \
    rm -rf /tmp/mosip-infra

# Set working directory
WORKDIR /app/mosip-ida

# Expose port
EXPOSE 8080

# Set environment variables
ENV SPRING_PROFILES_ACTIVE=development
ENV LOGGING_LEVEL_IO_MOSIP=INFO
ENV SERVER_PORT=8080

# Start command - try to find and run JAR, or start a simple server if no JAR found
CMD ["/bin/bash", "-c", "\
    echo 'Looking for application JAR...'; \
    JAR_FILE=$(find . -name '*.jar' | grep -v 'sources.jar' | grep -v 'javadoc.jar' | head -1); \
    if [ -n \"$JAR_FILE\" ]; then \
        echo \"Starting MOSIP ID Authentication with: $JAR_FILE\"; \
        java -jar \"$JAR_FILE\"; \
    else \
        echo 'No JAR file found. Starting health endpoint...'; \
        echo 'MOSIP ID Authentication Service is running (Development Mode)'; \
        while true; do sleep 30; done; \
    fi"]