---
description: Iteratively refine a Plan or SPEC until implementation-ready
arguments:
  - name: file
    description: Path to the Plan or SPEC file to refine
    required: true
---

Read the current Plan or SPEC at $ARGUMENTS.file and execute the following refinement process.

## Interview Process

1. **Analyze the current Plan** and identify:
   - Unclear points
   - Ambiguities
   - Undecided items
   - Missing details
   - Implicit assumptions

2. **Ask questions using AskUserQuestion tool**
   - Technical implementation details
   - UI/UX behavior specifics
   - Edge case handling strategies
   - Tradeoff decisions
   - Security and performance concerns
   - Future extensibility considerations
   - Integration points
   - Error scenarios

3. **Update the Plan** based on the answers received

4. **Re-analyze the updated Plan** and return to step 2 if new unclear points emerge

5. **Repeat until no unclear points remain**

## Important Rules

- Do NOT ask obvious questions (don't ask what can be understood from code or context)
- Dig deep (don't stop at surface-level questions)
- Don't miss new questions that arise from each answer
- Challenge vague statements like "handle appropriately" or "as needed"
- Ensure every decision has explicit rationale documented
- Refine the final Plan to an implementation-ready level of detail

## Output

The refined Plan should be detailed enough that implementation can begin without further clarification.
