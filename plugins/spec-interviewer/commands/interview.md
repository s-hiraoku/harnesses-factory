---
description: Conduct a detailed interview to build comprehensive specifications
arguments:
  - name: file
    description: Path to the spec file to read and update
    required: true
---

Read $ARGUMENTS.file and conduct a detailed interview to build comprehensive specifications.

## Topics to Cover

Use AskUserQuestion tool to dig deep into:

- **Technical Implementation**
  - Architecture decisions
  - Database design
  - API design
  - Technology stack choices

- **UI/UX**
  - Screen transitions
  - User interactions
  - Error displays
  - Loading states

- **Tradeoffs**
  - Performance vs maintainability
  - Features vs complexity
  - Build vs buy decisions

- **Concerns**
  - Security considerations
  - Scalability requirements
  - Cost implications
  - Compliance needs

- **Edge Cases**
  - Error handling strategies
  - Boundary value conditions
  - Race conditions
  - Failure recovery

## Interview Rules

1. Ask non-obvious questions that reveal hidden requirements
2. Generate follow-up questions based on answers (dig recursively)
3. Challenge assumptions and explore alternatives
4. Continue until all unclear points are resolved
5. Summarize findings before finalizing

## Output

After the interview is complete, update `$ARGUMENTS.file` with the detailed specification including all clarified requirements, decisions made, and rationale.
