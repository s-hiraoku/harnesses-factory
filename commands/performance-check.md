---
description: Analyze code for performance issues and optimization opportunities
argument-hint: [file-path or component]
---

Analyze performance for: $ARGUMENTS

## Instructions

1. **Profile Target**
   - Identify the code to analyze
   - Look for performance-critical sections

2. **Check for Common Issues**

   ### Algorithm Efficiency
   - O(n²) or worse algorithms
   - Unnecessary iterations
   - Redundant calculations

   ### Memory Usage
   - Large data structures
   - Memory leaks
   - Closure retention

   ### I/O Operations
   - Blocking operations
   - N+1 queries
   - Missing pagination

   ### Rendering (Frontend)
   - Unnecessary re-renders
   - Large component trees
   - Missing memoization

3. **Bundle Analysis** (if applicable)
   ```bash
   npx webpack-bundle-analyzer
   ```

4. **Output Format**

```markdown
## Performance Analysis

### Current State
- [baseline observations]

### Identified Issues

#### High Impact
1. [issue]
   - Location: [file:line]
   - Impact: [description]
   - Fix: [recommendation]

#### Medium Impact
1. [issue]

#### Low Impact
1. [issue]

### Optimization Recommendations

#### Quick Wins
1. [easy optimization]

#### Short-term
1. [medium effort improvement]

#### Long-term
1. [architectural improvement]

### Expected Improvements
- [metric]: [expected gain]
```
