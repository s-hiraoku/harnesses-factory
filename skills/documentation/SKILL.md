---
name: documentation
description: Documentation generation and maintenance. Creates README files, API docs, and code comments. Use when documenting code or projects.
---

# Documentation

## README Structure

```markdown
# Project Name

Brief description of the project.

## Features
- Feature 1
- Feature 2

## Installation

\`\`\`bash
npm install project-name
\`\`\`

## Quick Start

\`\`\`typescript
import { something } from 'project-name';
// example usage
\`\`\`

## API Reference

### function name
Description of what it does.

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| param1 | string | Description |

#### Returns
`ReturnType` - Description

## Contributing
See CONTRIBUTING.md

## License
MIT
```

## JSDoc Comments

```typescript
/**
 * Calculates the sum of two numbers.
 *
 * @param a - The first number
 * @param b - The second number
 * @returns The sum of a and b
 * @throws {Error} If either parameter is not a number
 *
 * @example
 * const sum = add(2, 3);
 * console.log(sum); // 5
 */
function add(a: number, b: number): number {
  return a + b;
}
```

## Inline Comments

### When to Comment
- Complex algorithms
- Non-obvious business logic
- Workarounds for known issues
- TODO items

### When NOT to Comment
- Self-explanatory code
- Restating what code does
- Commented-out code

## API Documentation

Use tools like:
- TypeDoc for TypeScript
- Swagger/OpenAPI for REST APIs
- GraphQL schema documentation
