# Spec Interviewer

Interactive specification builder through detailed interviews.

## Installation

```bash
claude plugins:add s-hiraoku/claude-code-harnesses-factory --path plugins/spec-interviewer
```

## Commands

### `/interview <file>`

Conducts a detailed interview to build comprehensive specifications from scratch.

**Usage:**
```
/interview specs/feature.md
```

**What it does:**
1. Reads the initial spec file
2. Asks probing questions about:
   - Technical implementation (architecture, DB, API)
   - UI/UX (screens, interactions, errors)
   - Tradeoffs (performance, complexity)
   - Concerns (security, scalability, cost)
   - Edge cases (errors, boundaries, race conditions)
3. Recursively generates follow-up questions
4. Updates the spec file with detailed findings

**Best for:**
- Fleshing out rough feature ideas
- Discovering hidden requirements
- Making technical decisions explicit
- Documenting edge cases early

---

### `/refine <file>`

Iteratively refines an existing Plan or SPEC until implementation-ready.

**Usage:**
```
/refine docs/plan.md
```

**What it does:**
1. Analyzes current Plan for unclear points and ambiguities
2. Asks targeted questions to resolve each issue
3. Updates the Plan with answers
4. Re-analyzes and repeats until fully clarified
5. Produces implementation-ready specification

**Best for:**
- Polishing draft specifications
- Resolving ambiguities before coding
- Ensuring nothing is left to interpretation
- Getting sign-off ready documents
