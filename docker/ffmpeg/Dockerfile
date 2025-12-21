# FFmpeg Docker Image for MBUY Studio
FROM jrottenberg/ffmpeg:5.1-alpine

# Install additional tools
RUN apk add --no-cache \
    bash \
    curl \
    jq \
    python3 \
    py3-pip

# Create directories
RUN mkdir -p /data/input /data/output /scripts

# Copy scripts
COPY scripts/ /scripts/
RUN chmod +x /scripts/*.sh 2>/dev/null || true

# Set working directory
WORKDIR /data

# Default command
CMD ["tail", "-f", "/dev/null"]
