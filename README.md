# Pentest MCP Server

A Model Context Protocol (MCP) server that provides security testing tools for educational purposes in controlled environments.

## ⚠️ IMPORTANT LEGAL NOTICE

**THIS SOFTWARE IS FOR EDUCATIONAL PURPOSES ONLY**

- Only use on systems you own or have explicit written permission to test
- Unauthorized penetration testing is illegal in most jurisdictions
- The developers assume no liability for misuse of this software
- Always comply with local laws and regulations

## Purpose

This MCP server provides a secure interface for AI assistants to perform penetration testing and security assessments on authorized systems through industry-standard security tools.

## Features

### Current Implementation

- **`nmap_scan`** - Network discovery and port scanning with multiple scan types (quick, full, stealth, ping)
- **`nikto_scan`** - Web server vulnerability scanning for misconfigurations and known issues
- **`sqlmap_test`** - Automated SQL injection testing on web application parameters
- **`wpscan_scan`** - WordPress-specific vulnerability scanning with plugin/theme enumeration
- **`dirb_scan`** - Directory and file brute-forcing for hidden web content discovery
- **`searchsploit_search`** - Search the exploit database for known vulnerabilities
- **`ping_test`** - Basic connectivity testing to verify target is reachable

## Prerequisites

- Docker Desktop with MCP Toolkit enabled
- Docker MCP CLI plugin (`docker mcp` command)
- Authorization to test target systems
- Understanding of ethical hacking principles

## Installation

See the step-by-step instructions in Section 2 below.

## Usage Examples

In Claude Desktop, you can ask:

- "Scan 192.168.1.1 with nmap using a quick scan"
- "Run nikto against http://testsite.local on port 80"
- "Test http://example.com/page?id=1 for SQL injection"
- "Scan http://wordpress-site.com for vulnerable plugins using wpscan"
- "Search for hidden directories on http://example.com using dirb"
- "Search exploitdb for apache 2.4 vulnerabilities"
- "Ping test 8.8.8.8 with 10 packets"

## Architecture
```
Claude Desktop → MCP Gateway → Pentest MCP Server → Security Tools
                                       ↓
                               (nmap, nikto, sqlmap,
                                wpscan, dirb, searchsploit)
```

## Development

### Local Testing
```bash
# Run directly (not recommended for production)
python3 pentest_server.py

# Test MCP protocol
echo '{"jsonrpc":"2.0","method":"tools/list","id":1}' | python3 pentest_server.py
```

### Adding New Tools

1. Install the tool in the Dockerfile
2. Add a sanitization function if needed
3. Create a new @mcp.tool() function in pentest_server.py
4. Update the catalog entry with the new tool name
5. Rebuild the Docker image

## Troubleshooting

### Tools Not Appearing
- Verify Docker image built successfully: `docker images | grep pentest`
- Check catalog and registry files are properly formatted
- Ensure Claude Desktop config includes custom catalog
- Restart Claude Desktop completely

### Permission Errors
- Verify the container has proper capabilities for network tools
- Check that non-root user has execute permissions
- Some tools may require specific network configurations

### Command Timeouts
- Increase timeout values in the code if needed
- Consider breaking large scans into smaller targets
- Some tools (sqlmap, wpscan) can take several minutes

## Security Considerations

- All commands are sanitized to prevent injection attacks
- Running as non-root user with minimal required capabilities
- Output is truncated to prevent excessive data exposure
- No credentials or sensitive data are logged
- Tools run in isolated Docker container
- Network access controlled by Docker networking

## Ethical Use Guidelines

1. **Authorization**: Always obtain written permission before testing
2. **Scope**: Stay within agreed-upon testing boundaries
3. **Documentation**: Keep detailed logs of all testing activities
4. **Disclosure**: Report findings responsibly to system owners
5. **Compliance**: Follow applicable laws and industry standards (e.g., PCI-DSS, GDPR)

## License

MIT License - See file for details

## Disclaimer

This tool is provided "as is" without warranty of any kind. The authors and contributors are not responsible for any misuse or damage caused by this software. Users are solely responsible for ensuring their use complies with all applicable laws and regulations.