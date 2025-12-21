---
paths: **/*.{ts,tsx,js,jsx}
---

# Code Style Rules

## TypeScript/JavaScript Standards

### Naming Conventions
- Variables and functions: `camelCase`
- Classes and types: `PascalCase`
- Constants: `UPPER_SNAKE_CASE`
- Files: `kebab-case.ts`

### Functions
- Keep functions under 50 lines
- Single responsibility per function
- Use arrow functions for callbacks
- Prefer named exports over default exports

### Formatting
- 2-space indentation
- Max line length: 100 characters
- Use semicolons
- Single quotes for strings

### Types
- Avoid `any` - use `unknown` if type is truly unknown
- Use interfaces for object shapes
- Use type for unions and intersections
- Export types that are part of public API

### Error Handling
```typescript
// Good
try {
  await riskyOperation();
} catch (error) {
  if (error instanceof SpecificError) {
    handleSpecificError(error);
  } else {
    throw error;
  }
}

// Avoid
try {
  await riskyOperation();
} catch (e) {
  console.log(e);
}
```

### Async/Await
- Always use async/await over .then()
- Handle errors appropriately
- Avoid unhandled promise rejections

### Imports
```typescript
// Order: external, internal, relative
import { something } from 'external-lib';
import { util } from '@/utils';
import { local } from './local';
```
