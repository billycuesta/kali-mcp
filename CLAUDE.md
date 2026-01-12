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

**Network & Discovery:**
1. **nmap** - Network scanning and OS detection
2. **enum4linux** - SMB/LDAP enumeration
3. **dnsutils** - DNS tools (dig, nslookup)

**Web Application:**
4. **nikto** - Web server vulnerability scanner
5. **sqlmap** - SQL injection testing
6. **wpscan** - WordPress vulnerability scanner
7. **dirb** - Web directory brute-force
8. **gobuster** - DNS/VHOST/directory fuzzing
9. **ffuf** - High-speed fuzzer
10. **feroxbuster** - Fast directory scanner
11. **nuclei** - Template-based vulnerability scanner
12. **wafw00f** - WAF detection
13. **zaproxy** - OWASP ZAP scanner
14. **tplmap** - SSTI/Template injection testing

**AWS Security:**
15. **aws-cli** - AWS API access
16. **prowler** - AWS security audit framework
17. **cloudfox** - AWS cloud intelligence (Bishop Fox)
18. **pacu** - AWS exploitation framework

**Internal Network & Exploitation:**
19. **crackmapexec** - SMB/LDAP/WinRM credential testing
20. **responder** - LLMNR/NBT-NS spoofing
21. **impacket** - Network protocol libraries
22. **metasploit-framework** - Exploit framework
23. **samba-tools** - SMB client tools

**Password Cracking:**
24. **hashcat** - GPU/CPU password cracking
25. **john** - Offline password cracker

**SSL/TLS Analysis:**
26. **testssl.sh** - SSL/TLS security analysis

**Utilities:**
27. **exploitdb** - Exploit database with searchsploit
28. **paramspider** - Parameter discovery
29. **exiftool** - Metadata extraction
30. **libreoffice** - Office document analysis
31. **hydra** - Service brute-force (included in framework)

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

## AWS SECURITY TOOLS

### prowler_scan(profile, regions)

Comprehensive AWS security audit using Prowler.

**Parameters:**
- `profile`: AWS CLI profile name (default: "default")
- `regions`: Regions to scan (default: "us-east-1")

**Example:** "Run Prowler scan with profile production in us-east-1,eu-west-1"

### cloudfox_aws(profile, operation)

AWS cloud intelligence using CloudFox (Bishop Fox).

**Parameters:**
- `profile`: AWS CLI profile (default: "default")
- `operation`: Operation - all, buckets, instances, iam, networking, etc. (default: "all")

**Example:** "CloudFox scan for all AWS resources"

### pacu_scan(command_name)

AWS exploitation framework PACU commands.

**Parameters:**
- `command_name`: PACU command to execute (default: "whoami")

**Example:** "Run PACU reconnaissance on AWS environment"

## INTERNAL NETWORK TOOLS

### crackmapexec_spray(protocol, targets, username, password)

Credential spraying and SMB/LDAP enumeration.

**Parameters:**
- `protocol`: Protocol type (smb, ldap, winrm, ssh, etc.) (default: "smb")
- `targets`: Target IPs/ranges (required)
- `username`: Username for credentials (optional)
- `password`: Password for credentials (optional)

**Example:** "Spray credentials across 192.168.1.0/24 using SMB"

### enum4linux_scan(target, user, password)

Enumerate SMB/LDAP services.

**Parameters:**
- `target`: Target IP/hostname (required)
- `user`: Username (optional)
- `password`: Password (optional)

**Example:** "Full enumeration of domain controller at 192.168.1.1"

### responder_listen(interface, duration)

Capture LLMNR/NBT-NS traffic (internal networks).

**Parameters:**
- `interface`: Network interface (default: "eth0")
- `duration`: Listen duration in seconds (default: "60")

**Example:** "Listen for LLMNR traffic on eth0 for 5 minutes"

## PASSWORD CRACKING

### hashcat_crack(hashfile, hashtype, wordlist)

Fast GPU/CPU password cracking.

**Parameters:**
- `hashfile`: Path to hash file (required)
- `hashtype`: Hash type ID (0=MD5, 1=MD5(Unix), 3=MD5(salt), etc.) (required)
- `wordlist`: Wordlist path (default: "/usr/share/wordlists/rockyou.txt")

**Example:** "Crack MD5 hashes from hashes.txt"

### john_crack(hashfile, format_type)

Password cracking with John the Ripper.

**Parameters:**
- `hashfile`: Path to hash file (required)
- `format_type`: Hash format (auto, md5, sha512, etc.) (default: "auto")

**Example:** "Crack shadow file format with John"

## WEB SCANNING & FUZZING

### nuclei_scan(url, templates)

Template-based vulnerability scanning.

**Parameters:**
- `url`: Target URL (required)
- `templates`: Template category (cves, vulnerability, misconfig, etc.) (default: "cves")

**Example:** "Scan with Nuclei CVE templates"

### feroxbuster_scan(url, wordlist)

Fast directory brute-force.

**Parameters:**
- `url`: Target URL (required)
- `wordlist`: Custom wordlist path (optional)

**Example:** "Brute-force directories on example.com"

### ffuf_fuzz(url, wordlist, keyword)

High-speed web fuzzer.

**Parameters:**
- `url`: Target URL with FUZZ placeholder (required)
- `wordlist`: Custom wordlist (optional)
- `keyword`: Fuzz keyword (default: "FUZZ")

**Example:** "Fuzz parameters on http://example.com/api?id=FUZZ"

### wafw00f_detect(url)

Detect WAF/IPS/IDS protection.

**Parameters:**
- `url`: Target URL (required)

**Example:** "Detect WAF protecting example.com"

### gobuster_fuzz(url, wordlist, mode)

Web directory/DNS/VHOST fuzzing.

**Parameters:**
- `url`: Target URL (required)
- `wordlist`: Custom wordlist (optional)
- `mode`: Fuzz mode - dir, dns, vhost (default: "dir")

**Example:** "Find virtual hosts on example.com"

## SSL/TLS ANALYSIS

### testssl_check(target)

Deep SSL/TLS security analysis.

**Parameters:**
- `target`: Target host:port (required)

**Example:** "Analyze SSL/TLS on example.com:443"

## AWS CLI DIRECT

### aws_cli_command(command, profile)

Execute AWS CLI commands directly.

**Parameters:**
- `command`: AWS CLI subcommand (s3 ls, ec2 describe-instances, iam list-users, etc.) (required)
- `profile`: AWS CLI profile (default: "default")

**Example:** "List all S3 buckets with profile production"

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