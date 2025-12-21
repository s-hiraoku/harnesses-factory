---
description: Generate comprehensive test suite for a file or component
argument-hint: [file-path]
---

Generate a comprehensive test suite for: $ARGUMENTS

## Instructions

1. **Detect Testing Framework**
   - Check package.json for jest, vitest, mocha, etc.
   - Find existing test configuration files
   - Match existing test patterns in the project

2. **Analyze Target Code**
   - Identify all functions, classes, and methods
   - Map dependencies and side effects
   - Determine test boundaries

3. **Create Tests**

   ### Unit Tests
   - Test each function independently
   - Mock external dependencies
   - Cover happy paths and error cases

   ### Integration Tests (if applicable)
   - Test component interactions
   - Test API endpoints
   - Test database operations

   ### Edge Cases
   - Empty/null inputs
   - Boundary values
   - Error conditions

4. **Follow Conventions**
   - Use AAA pattern (Arrange, Act, Assert)
   - Descriptive test names
   - Proper setup/teardown
   - Target 80%+ coverage

5. **Output**
   - Create test file in appropriate location
   - Follow project naming conventions (*.test.ts or *.spec.ts)
   - Include necessary imports and mocks
