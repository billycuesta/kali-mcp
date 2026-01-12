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
    metasploit-framework \
    hydra \
    john \
    hashcat \
    enum4linux \
    samba-tools \
    testssl.sh \
    libreoffice \
    exiftool \
    gobuster \
    ffuf \
    feroxbuster \
    zaproxy \
    wafw00f \
    awscli \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Update exploitdb
RUN searchsploit -u || true

# Install Python-based tools
RUN pip3 install --no-cache-dir --break-system-packages \
    impacket \
    crackmapexec \
    responder \
    nuclei \
    paramspider \
    tplmap \
    prowler \
    pacu \
    bloodhound

# Install cloudfox from GitHub
RUN wget -q https://github.com/BishopFox/cloudfox/releases/download/v2.4.2/cloudfox-linux-amd64 -O /usr/local/bin/cloudfox && \
    chmod +x /usr/local/bin/cloudfox

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