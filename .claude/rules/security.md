---
paths: **/*
---

# Security Rules

## Never Commit Secrets

Do not hardcode:
- API keys
- Passwords
- Database connection strings
- Private keys
- Tokens

Use environment variables instead:
```typescript
// Bad
const apiKey = 'sk-1234567890';

// Good
const apiKey = process.env.API_KEY;
```

## Input Validation

Always validate external input:
```typescript
// Validate user input
const schema = z.object({
  email: z.string().email(),
  age: z.number().min(0).max(150),
});

const validated = schema.parse(userInput);
```

## SQL Injection Prevention

Use parameterized queries:
```typescript
// Bad
const query = `SELECT * FROM users WHERE id = ${userId}`;

// Good
const query = 'SELECT * FROM users WHERE id = $1';
const result = await db.query(query, [userId]);
```

## XSS Prevention

Sanitize user-generated content:
```typescript
// Bad
element.innerHTML = userContent;

// Good
element.textContent = userContent;
// Or use a sanitizer
element.innerHTML = DOMPurify.sanitize(userContent);
```

## Dependencies

- Keep dependencies updated
- Run `npm audit` regularly
- Review new dependencies before adding
- Prefer well-maintained packages with active security support
