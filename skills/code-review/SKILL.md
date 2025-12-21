---
name: code-review
description: Code review best practices. Provides structured feedback on code quality, security, and maintainability. Use when reviewing code changes.
allowed-tools: Read, Grep, Glob
---

# Code Review

## Review Checklist

### Code Quality
- [ ] Code is readable and self-documenting
- [ ] Functions are small and focused
- [ ] Names are descriptive and consistent
- [ ] No code duplication (DRY)
- [ ] Error handling is appropriate

### Security
- [ ] No hardcoded secrets
- [ ] Input validation present
- [ ] No SQL injection risks
- [ ] No XSS vulnerabilities
- [ ] Authentication/authorization checked

### Performance
- [ ] No obvious N+1 queries
- [ ] Appropriate caching
- [ ] Efficient algorithms
- [ ] No memory leaks

### Testing
- [ ] Tests cover new functionality
- [ ] Edge cases tested
- [ ] Test names are descriptive

## Feedback Format

```markdown
## Summary
[Brief overview of the changes]

## Approval Status
- [ ] Approved
- [ ] Changes Requested
- [ ] Needs Discussion

## Detailed Feedback

### Critical
[Must fix before merge]

### Suggestions
[Recommended improvements]

### Praise
[What was done well]
```

## Best Practices

1. **Be Constructive**: Focus on the code, not the author
2. **Explain Why**: Don't just say "change this", explain the reasoning
3. **Prioritize**: Clearly distinguish must-fix from nice-to-have
4. **Be Timely**: Review promptly to avoid blocking progress
5. **Acknowledge Good Work**: Highlight well-written code
