# Pentest MCP Server - Implementation Guide

## Overview

This MCP server integrates common penetration testing tools into Claude Desktop, allowing security professionals and students to perform authorized security assessments through conversational AI.

## Architecture Decisions

### Base Image: Kali Linux

We chose Kali Linux Rolling as the base image because:
- Pre-packaged with most security tools we need
- Regularly updated with latest tool versions
- Well-maintained and widely used in security community
- Includes proper dependencies and configurations

### Security Tools Included

1. **nmap** - Network discovery and security auditing
2. **nikto** - Web server scanner
3. **sqlmap** - Automated SQL injection tool
4. **wpscan** - WordPress security scanner
5. **dirb** - Web content scanner
6. **exploitdb** - Exploit database with searchsploit

### Security Model

- **Non-root execution**: Container runs as mcpuser (UID 1000)
- **Capabilities**: Network tools granted minimal required capabilities via setcap
- **Input sanitization**: All user inputs validated against injection attacks
- **Output truncation**: Large outputs limited to prevent memory issues
- **Timeout enforcement**: All commands have reasonable timeout limits

## Tool Functions

### nmap_scan(target, scan_type)

Performs network scanning with multiple scan profiles:
- `quick`: Fast scan of common ports (-T4 -F)
- `full`: Comprehensive scan with OS detection (-T4 -A -v)
- `stealth`: SYN scan with slow timing (-sS -T2)
- `ping`: Host discovery only (-sn)

**Parameters:**
- `target`: IP address or hostname (required)
- `scan_type`: Scan profile (default: "quick")

**Example:** "Scan 192.168.1.0/24 with nmap using stealth mode"

### nikto_scan(target, port)

Scans web servers for vulnerabilities and misconfigurations.

**Parameters:**
- `target`: URL or IP address (required)
- `port`: Port number (default: "80")

**Example:** "Run nikto against http://testsite.local on port 8080"

### sqlmap_test(url, parameter)

Tests web applications for SQL injection vulnerabilities.

**Parameters:**
- `url`: Full URL with query parameters (required)
- `parameter`: Specific parameter to test (optional)

**Example:** "Test http://example.com/login.php?user=admin for SQL injection"

### wpscan_scan(url, enumerate)

Scans WordPress installations for vulnerabilities.

**Parameters:**
- `url`: WordPress site URL (required)
- `enumerate`: What to enumerate - p (plugins), t (themes), u (users) (default: "p")

**Example:** "Scan http://wordpress-site.com and enumerate all plugins"

### dirb_scan(url, wordlist)

Discovers hidden directories and files on web servers.

**Parameters:**
- `url`: Target URL (required)
- `wordlist`: Wordlist to use - common or big (default: "common")

**Example:** "Search for hidden directories on http://example.com using the big wordlist"

### searchsploit_search(query)

Searches the exploit database for known vulnerabilities.

**Parameters:**
- `query`: Search terms (required)

**Example:** "Search exploitdb for nginx remote code execution"

### ping_test(target, count)

Basic connectivity test.

**Parameters:**
- `target`: IP or hostname (required)
- `count`: Number of packets (default: "4")

**Example:** "Ping test google.com with 10 packets"

## Input Sanitization

All target inputs go through `sanitize_target()` which:
- Strips whitespace
- Validates against a restrictive regex: `^[a-zA-Z0-9\.\-\_\:\/]+$`
- Prevents command injection via special characters
- Raises ValueError for invalid inputs

This ensures only legitimate targets can be scanned.

## Error Handling

Each tool function implements three layers of error handling:

1. **Input validation**: Checks for empty or malformed inputs
2. **Command execution**: Catches subprocess errors and timeouts
3. **Output formatting**: Formats errors consistently with emoji indicators

All errors are logged to stderr and returned as user-friendly messages.

## Output Formatting

Responses use consistent emoji indicators:
- ✅ Success
- ❌ Error
- ⚠️ Warning
- ⏱️ Timeout

Long outputs are automatically truncated to the first 100 lines to prevent overwhelming Claude's context window.

## Limitations

1. **Timeout constraints**: Long-running scans may timeout (default: 60-180s)
2. **Output truncation**: Large scan results are cut off after 100 lines
3. **Network access**: Requires proper Docker networking configuration
4. **Capabilities**: Some advanced features may require additional container capabilities
5. **Interactive tools**: Tools requiring user interaction won't work in this context

## Future Enhancements

Potential additions:
- Metasploit framework integration
- Burp Suite CLI integration
- Custom scan profile creation
- Report generation and export
- Scan result persistence
- Scheduled/automated scanning
- Integration with vulnerability databases

## Compliance Notes

When using this server:
- Maintain detailed audit logs
- Obtain proper authorization documentation
- Follow responsible disclosure practices
- Comply with OWASP, PTES, or other testing standards
- Consider data protection regulations (GDPR, CCPA, etc.)

## References

- [Kali Linux Documentation](https://www.kali.org/docs/)
- [OWASP Testing Guide](https://owasp.org/www-project-web-security-testing-guide/)
- [PTES Technical Guidelines](http://www.pentest-standard.org/index.php/Main_Page)
- [MCP Protocol Specification](https://modelcontextprotocol.io/)