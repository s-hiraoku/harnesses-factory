---
name: testing
description: Test development best practices. Guides test creation, coverage analysis, and testing strategies. Use when writing or improving tests.
---

# Testing

## Test Structure

### AAA Pattern
```typescript
describe('Calculator', () => {
  describe('add', () => {
    it('should return sum of two positive numbers', () => {
      // Arrange
      const calc = new Calculator();

      // Act
      const result = calc.add(2, 3);

      // Assert
      expect(result).toBe(5);
    });
  });
});
```

## Test Types

### Unit Tests
- Test individual functions/methods
- Mock external dependencies
- Fast execution
- High coverage target

### Integration Tests
- Test component interactions
- Real dependencies when possible
- API endpoint testing
- Database operations

### E2E Tests
- Test complete user flows
- Browser automation
- Critical path coverage
- Slower execution

## Mocking Strategies

```typescript
// Mock a module
jest.mock('./api', () => ({
  fetchUser: jest.fn().mockResolvedValue({ id: 1, name: 'Test' })
}));

// Mock implementation
const mockFn = jest.fn()
  .mockReturnValueOnce('first')
  .mockReturnValueOnce('second');

// Spy on existing method
jest.spyOn(object, 'method').mockImplementation(() => 'mocked');
```

## Test Data

### Factories
```typescript
const createUser = (overrides = {}) => ({
  id: faker.datatype.uuid(),
  name: faker.person.fullName(),
  email: faker.internet.email(),
  ...overrides
});
```

## Coverage Goals
- Statements: 80%+
- Branches: 75%+
- Functions: 80%+
- Lines: 80%+

Focus on critical paths over hitting numbers.
