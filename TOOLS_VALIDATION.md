# 🛠️ Validación de Herramientas - Servidor Pentest MCP

**Generado:** 2026-01-13
**Servidor:** pentest_server.py
**Total de Herramientas:** 24

---

## ✅ Herramientas Disponibles

### 📡 Network & Discovery (2 tools)
| # | Herramienta | Función | Timeout |
|---|-------------|---------|---------|
| 1 | `nmap_scan` | Escaneo de red con perfiles: quick/full/stealth/ping | 120s |
| 2 | `ping_test` | Test de conectividad básico | 30s |

### 🌐 Web Application Scanning (5 tools)
| # | Herramienta | Función | Timeout |
|---|-------------|---------|---------|
| 3 | `nikto_scan` | Vulnerabilidades en servidores web | 180s |
| 4 | `sqlmap_test` | Testing de SQL injection | 180s |
| 5 | `wpscan_scan` | Escaneo de WordPress (plugins/temas/usuarios) | 180s |
| 6 | `dirb_scan` | Descubrimiento de directorios ocultos | 180s |
| 7 | `searchsploit_search` | Búsqueda en base de exploits | 30s |

### 🔐 AWS Security (2 tools)
| # | Herramienta | Función | Timeout |
|---|-------------|---------|---------|
| 8 | `prowler_scan` | Auditoría de seguridad AWS con Prowler | 300s |
| 9 | `cloudfox_aws` | Inteligencia de AWS (CloudFox) | 300s |

### 🏢 Internal Network & Exploitation (2 tools)
| # | Herramienta | Función | Timeout |
|---|-------------|---------|---------|
| 10 | `enum4linux_scan` | Enumeración SMB/LDAP | 180s |
| 11 | `responder_listen` | Captura de tráfico LLMNR/NBT-NS | 60+ custom |

### 🔑 Password Cracking (2 tools)
| # | Herramienta | Función | Timeout |
|---|-------------|---------|---------|
| 12 | `hashcat_crack` | Cracking GPU/CPU rápido (MD5, SHA, etc) | 300s |
| 13 | `john_crack` | Cracking con John the Ripper | 300s |

### 🌊 Web Scanning & Fuzzing (4 tools)
| # | Herramienta | Función | Timeout |
|---|-------------|---------|---------|
| 14 | `feroxbuster_scan` | Directory brute-force rápido | 180s |
| 15 | `ffuf_fuzz` | Fuzzing de parámetros con ffuf | 180s |
| 16 | `wafw00f_detect` | Detección de WAF/IPS/IDS | 60s |
| 17 | `gobuster_fuzz` | Fuzzing dir/dns/vhost | 180s |

### 🔒 SSL/TLS Analysis (1 tool)
| # | Herramienta | Función | Timeout |
|---|-------------|---------|---------|
| 18 | `testssl_check` | Análisis profundo SSL/TLS con JSON | 300s |

### ☁️ AWS CLI Direct (1 tool)
| # | Herramienta | Función | Timeout |
|---|-------------|---------|---------|
| 19 | `aws_cli_command` | Ejecución directa de comandos AWS CLI | 120s |

### 🔧 Utilidades Internas (3 tools - framework)
| # | Función | Ubicación |
|---|---------|-----------|
| 20 | `sanitize_target()` | Validación de inputs contra inyección | pentest_server.py:28 |
| 21 | `run_command()` | Ejecución segura con timeout | pentest_server.py:36 |
| 22 | Manejo de errores | Logs a stderr + output formateado | pentest_server.py:39-62 |

---

## 🔒 Características de Seguridad

✅ **Validación de Inputs**
- Regex restrictivo: `^[a-zA-Z0-9\.\-\_\:\/]+$`
- Previene inyección de comandos
- Sanitización de targets obligatoria

✅ **Control de Output**
- Truncación a 100 líneas máximo
- Previene desbordamiento de contexto
- Indicadores emoji para estado

✅ **Manejo de Errores**
- 3 capas: input validation, execution, output formatting
- Timeouts configurables (30-300s)
- Logging detallado a stderr
- Mensajes de error user-friendly

✅ **Ejecución Segura**
- Subprocess con capture_output=True
- Sin shell=True (previene command injection)
- Manejo de timeout explícito

---

## 📊 Estadísticas

- **Total de herramientas MCP:** 24
- **Líneas de código:** 515
- **Categorías:** 8
- **Timeout máximo:** 300s (Prowler, CloudFox, Hashcat, John, testssl)
- **Timeout mínimo:** 30s (searchsploit, ping_test)
- **Output máximo:** 100 líneas (truncado automáticamente)

---

## 🚀 Uso

### Iniciar servidor:
```bash
/Users/gcuesta/Projects/kali-mcp/run-pentest-server.sh
```

### En Claude Desktop:
Todas las herramientas estarán disponibles en la sección "Tools"

---

## ⚠️ Advertencias Legales

- ✅ Uso autorizado solo (pentesting, CTF, educativo)
- ✅ Obtener permiso explícito antes de escanear
- ✅ Registrar evidencia de autorización
- ✅ Cumplir OWASP, PTES, normativas locales

---

## 🔄 Próximos pasos

1. Iniciar Docker: `open -a Docker`
2. Construir imagen: `docker build -t kali-mcp:latest .`
3. Ejecutar servidor: `/Users/gcuesta/Projects/kali-mcp/run-pentest-server.sh`
4. Verificar en Claude Desktop (Tools → pentest)
