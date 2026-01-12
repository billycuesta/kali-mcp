# Publishing Pentest MCP Server to Official Catalog

## Overview

Guide to publish this server to the official MCP catalog at https://github.com/modelcontextprotocol/servers

## Prerequisites

- GitHub account
- Fork of modelcontextprotocol/servers repository
- Docker Hub account (optional, for image hosting)

## Publication Steps

### 1. Prepare Repository

Ensure your repo has:
- ✅ Clear README.md with usage examples
- ✅ LICENSE file (MIT recommended)
- ✅ Complete Dockerfile
- ✅ requirements.txt with pinned versions
- ✅ CLAUDE.md with implementation details
- ✅ Security and compliance warnings

### 2. Create Package Metadata

Create `package.json` for npm registry (optional but recommended):

```json
{
  "name": "@your-username/pentest-mcp-server",
  "version": "1.0.0",
  "description": "MCP server integrating Kali Linux penetration testing tools",
  "keywords": ["mcp", "security", "pentesting", "kali-linux"],
  "license": "MIT",
  "repository": {
    "type": "git",
    "url": "https://github.com/your-username/kali-mcp"
  }
}
```

### 3. Publish to Docker Hub (Recommended)

```bash
# Tag image
docker tag kali-mcp your-username/pentest-mcp:latest

# Login to Docker Hub
docker login

# Push image
docker push your-username/pentest-mcp:latest
```

### 4. Submit to MCP Catalog

1. **Fork** https://github.com/modelcontextprotocol/servers

2. **Add entry** to `src/servers.json`:

```json
{
  "name": "pentest",
  "displayName": "Pentest Tools (Kali Linux)",
  "description": "Integration of common penetration testing tools from Kali Linux including nmap, nikto, sqlmap, wpscan, and more. For authorized security testing only.",
  "repository": "https://github.com/your-username/kali-mcp",
  "docker": {
    "image": "your-username/pentest-mcp:latest",
    "args": ["run", "-i", "--rm", "--network=host"]
  },
  "categories": ["security", "tools"],
  "tags": ["pentesting", "security", "nmap", "nikto", "sqlmap"],
  "license": "MIT",
  "author": {
    "name": "Your Name",
    "url": "https://github.com/your-username"
  },
  "warnings": [
    "Only use on systems you own or have explicit written authorization to test",
    "Some tools may trigger IDS/IPS systems",
    "Check local laws regarding security testing"
  ]
}
```

3. **Create PR** with description:
```markdown
## New Server: Pentest Tools (Kali Linux)

Adds MCP server integrating common penetration testing tools.

### Features
- Network scanning (nmap)
- Web vulnerability scanning (nikto, dirb)
- SQL injection testing (sqlmap)
- WordPress security scanning (wpscan)
- Exploit database search (searchsploit)

### Security Considerations
- Non-root execution
- Input sanitization
- Output truncation
- Timeout enforcement
- Clear authorization warnings

### Testing
- Tested with Claude Desktop on macOS
- Docker image builds successfully
- All tools execute correctly within container

### Compliance
Includes prominent warnings about authorization requirements and responsible use.
```

### 5. Alternative: Standalone Distribution

If not accepted to official catalog, distribute via:

**GitHub Releases:**
- Tag versions with semantic versioning
- Include docker-compose.yml
- Add installation scripts

**Docker Hub:**
- Public image ready to use
- Tagged versions
- Usage docs in image labels

## Current Status

- ✅ Code complete
- ✅ Local testing successful
- ✅ Documentation written
- ⏳ Awaiting Docker Hub publication
- ⏳ Awaiting catalog submission

## Configuration Example

Users would add to `claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "pentest": {
      "command": "docker",
      "args": ["run", "-i", "--rm", "--network=host", "your-username/pentest-mcp"]
    }
  }
}
```

## Maintenance Plan

- **Security updates**: Monitor Kali Linux base image updates
- **Tool updates**: Update when major version changes occur
- **Bug fixes**: Address issues reported by users
- **Feature requests**: Consider community suggestions

## Legal Considerations

Include in all documentation:
- Authorization requirements
- Responsible disclosure practices
- CFAA compliance (US)
- Computer Misuse Act compliance (UK)
- Local law compliance

## Marketing

Potential channels:
- MCP community forum
- InfoSec subreddits (r/netsec, r/AskNetsec)
- Security Twitter/X
- Blog post with tutorial
- YouTube demo video

## Support

Consider:
- GitHub Discussions for Q&A
- Issue templates
- Contributing guidelines
- Security vulnerability reporting process
