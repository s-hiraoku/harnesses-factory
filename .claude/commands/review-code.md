---
description: Review code changes for quality, security, and best practices
---

Review the current code changes for quality, security, and best practices.

## Instructions

1. **Get Changes**
   ```bash
   git diff --staged
   # or if no staged changes
   git diff HEAD~1
   ```

2. **Code Quality Review**
   - Readability and clarity
   - Function and variable naming
   - Code duplication
   - Single responsibility
   - Error handling

3. **Security Review**
   - Hardcoded secrets
   - Input validation
   - SQL injection risks
   - XSS vulnerabilities
   - Authentication checks

4. **Performance Review**
   - N+1 queries
   - Inefficient algorithms
   - Memory leaks
   - Resource cleanup

5. **Testing Review**
   - Test coverage for new code
   - Edge cases covered
   - Test quality

6. **Output Format**

```markdown
## Code Review Summary

### Files Reviewed
- [list of files]

### Critical Issues (must fix)
1. [issue with location and fix suggestion]

### Warnings (should fix)
1. [warning with recommendation]

### Suggestions (nice to have)
1. [suggestion]

### Positive Observations
- [what was done well]

### Approval Status
- [ ] Approved
- [ ] Changes Requested
```
