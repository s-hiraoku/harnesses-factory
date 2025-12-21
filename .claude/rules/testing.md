---
paths: **/*.{test,spec}.{ts,tsx,js,jsx}
---

# Testing Rules

## Test Naming

Use descriptive names that explain the behavior:
```typescript
// Bad
it('works', () => {});

// Good
it('should return user when valid ID is provided', () => {});
```

## Test Structure

Follow AAA pattern:
```typescript
it('should calculate total with discount', () => {
  // Arrange
  const cart = new Cart();
  cart.add(item1, item2);
  const discount = 0.1;

  // Act
  const total = cart.calculateTotal(discount);

  // Assert
  expect(total).toBe(90);
});
```

## Mocking

- Mock external dependencies, not internal logic
- Use factories for test data
- Reset mocks between tests

```typescript
beforeEach(() => {
  jest.clearAllMocks();
});
```

## Coverage

Target coverage:
- Statements: 80%+
- Branches: 75%+
- Functions: 80%+
- Lines: 80%+

Focus on critical paths over hitting numbers.

## Edge Cases

Always test:
- Empty/null inputs
- Boundary values
- Error conditions
- Concurrent operations
