# Installation Guide

## Prerequisites
- Docker Desktop with MCP support
- Claude Desktop or Claude Code

## Quick Setup

### 1. Build the Docker image
```bash
cd /path/to/kali-mcp
docker build -t pentest-mcp-server:latest .
```

### 2. Configure Docker MCP

Copy the catalog configuration:
```bash
cp docker-mcp-config/catalogs/custom.yaml ~/.docker/mcp/catalogs/
```

Add pentest to your registry (edit `~/.docker/mcp/registry.yaml`):
```yaml
registry:
  pentest:
    ref: ""
```

### 3. Verify Installation

In Claude Code:
```
mcp-find pentest
mcp-add pentest
```

## Available Tools

| Tool | Description |
|------|-------------|
| `nmap_scan` | Network scanning |
| `nikto_scan` | Web server vulnerability scanner |
| `sqlmap_test` | SQL injection testing |
| `wpscan_scan` | WordPress security scanner |
| `dirb_scan` | Directory brute forcing |
| `searchsploit_search` | Exploit database search |
| `ping_test` | Connectivity test |

## Usage Examples

```
# Scan a network
nmap_scan target="192.168.1.0/24" scan_type="quick"

# Check web server
nikto_scan target="http://example.com" port="80"

# Find exploits
searchsploit_search query="apache 2.4"
```

## ⚠️ Legal Notice

Only use these tools on systems you have explicit permission to test.
