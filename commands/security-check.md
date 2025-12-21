---
description: Run security audit on the codebase
---

Perform a comprehensive security audit of the codebase.

## Instructions

1. **Dependency Audit**
   ```bash
   npm audit
   ```
   Review and report vulnerabilities.

2. **Secret Detection**
   Search for potential secrets:
   - API keys
   - Passwords
   - Private keys
   - Tokens
   - Connection strings

3. **Code Review**
   Check for:
   - SQL injection vulnerabilities
   - XSS vulnerabilities
   - Command injection
   - Path traversal
   - Insecure deserialization
   - Hardcoded credentials

4. **Configuration Review**
   - CORS settings
   - Authentication configuration
   - Rate limiting
   - HTTPS enforcement

5. **Output Format**

```markdown
## Security Audit Report

### Summary
- Risk Level: [Critical/High/Medium/Low]
- Total Issues: [number]

### Dependency Vulnerabilities
[npm audit summary]

### Code Vulnerabilities
1. [vulnerability type]
   - Location: [file:line]
   - Severity: [level]
   - Fix: [recommendation]

### Secret Exposure Risks
[findings]

### Configuration Issues
[findings]

### Recommendations
1. Immediate actions
2. Short-term improvements
3. Long-term enhancements
```
