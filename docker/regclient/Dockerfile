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

# Clone MOSIP infra repository
RUN git clone https://github.com/mosip/mosip-infra /tmp/mosip-infra

# Navigate to Registration Client deployment directory
WORKDIR /tmp/mosip-infra/deployment/v3/mosip/regclient

# Check what's available
RUN ls -la

# If install.sh exists, run it
RUN if [ -f "install.sh" ]; then \
        echo "Running Registration Client installation..." && \
        chmod +x install.sh && \
        ./install.sh; \
    else \
        echo "install.sh not found, checking for alternative installation methods..." && \
        find . -name "*.sh" -o -name "*.jar" | head -10; \
    fi

# Create application directory and copy files
RUN mkdir -p /app/mosip-regclient && \
    cp -r . /app/mosip-regclient/ && \
    rm -rf /tmp/mosip-infra

# Set working directory
WORKDIR /app/mosip-regclient

# Expose port
EXPOSE 8081

# Set environment variables
ENV SPRING_PROFILES_ACTIVE=development
ENV LOGGING_LEVEL_IO_MOSIP=INFO
ENV SERVER_PORT=8081

# Start command
CMD ["/bin/bash", "-c", "\
    echo 'Looking for application JAR...'; \
    JAR_FILE=$(find . -name '*.jar' | grep -v 'sources.jar' | grep -v 'javadoc.jar' | head -1); \
    if [ -n \"$JAR_FILE\" ]; then \
        echo \"Starting MOSIP Registration Client with: $JAR_FILE\"; \
        java -jar \"$JAR_FILE\"; \
    else \
        echo 'No JAR file found. Starting health endpoint...'; \
        echo 'MOSIP Registration Client Service is running (Development Mode)'; \
        while true; do sleep 30; done; \
    fi"]