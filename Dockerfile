# Use Kali Linux rolling as base
FROM kalilinux/kali-rolling:latest

# Set working directory
WORKDIR /app

# Set Python unbuffered mode
ENV PYTHONUNBUFFERED=1

# Update and install required tools from APT
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    nmap \
    nikto \
    sqlmap \
    wpscan \
    dirb \
    exploitdb \
    net-tools \
    iputils-ping \
    dnsutils \
    curl \
    wget \
    git \
    hydra \
    john \
    hashcat \
    enum4linux \
    samba-common-bin \
    libreoffice \
    exiftool \
    gobuster \
    ffuf \
    feroxbuster \
    awscli \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Python-based tools (only verified PyPI packages)
RUN pip3 install --no-cache-dir --break-system-packages \
    impacket \
    responder \
    wafw00f \
    prowler || echo "⚠️ Some pip packages failed to install"

# Install CloudFox v1.17.0 (latest with ARM64 support)
RUN ARCH=$(dpkg --print-architecture) && \
    apt-get update && apt-get install -y unzip && \
    if [ "$ARCH" = "amd64" ]; then \
      wget -q https://github.com/BishopFox/cloudfox/releases/download/v1.17.0/cloudfox-linux-amd64.zip -O /tmp/cloudfox.zip; \
    elif [ "$ARCH" = "arm64" ]; then \
      wget -q https://github.com/BishopFox/cloudfox/releases/download/v1.17.0/cloudfox-linux-arm64.zip -O /tmp/cloudfox.zip; \
    fi && \
    unzip -o /tmp/cloudfox.zip -d /tmp && \
    mv /tmp/cloudfox/cloudfox /usr/local/bin/cloudfox && \
    chmod +x /usr/local/bin/cloudfox && \
    rm -rf /tmp/cloudfox /tmp/cloudfox.zip && \
    apt-get clean

# Copy requirements first for better caching
COPY requirements.txt .

# Install Python dependencies for MCP server
RUN pip3 install --no-cache-dir -r requirements.txt --break-system-packages

# Copy the server code
COPY pentest_server.py .

# Create non-root user
RUN useradd -m -u 1000 mcpuser && \
    chown -R mcpuser:mcpuser /app && \
    # Grant network capabilities to tools
    setcap cap_net_raw,cap_net_admin,cap_net_bind_service+eip /usr/bin/nmap || true && \
    setcap cap_net_raw,cap_net_admin+eip /usr/bin/hashcat || true && \
    # Ensure cloudfox is executable
    chmod +x /usr/local/bin/cloudfox

# Switch to non-root user
# USER mcpuser

# Run the server
CMD ["python3", "pentest_server.py"]