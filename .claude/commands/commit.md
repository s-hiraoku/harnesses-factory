---
description: Create a git commit with conventional commit message
allowed-tools: Bash(git add:*), Bash(git status:*), Bash(git commit:*), Bash(git diff:*)
argument-hint: [optional message]
---

Create a git commit with a conventional commit message.

## Context

- Current git status: !`git status --short`
- Staged changes: !`git diff --staged --stat`

## Instructions

1. **Analyze Changes**
   - Review staged changes
   - Determine the type of change (feat, fix, docs, etc.)
   - Identify the scope

2. **Generate Commit Message**
   Follow Conventional Commits format:
   ```
   <type>(<scope>): <description>

   [optional body]

   [optional footer]
   ```

   ### Types
   - `feat`: New feature
   - `fix`: Bug fix
   - `docs`: Documentation
   - `style`: Formatting
   - `refactor`: Code refactoring
   - `perf`: Performance
   - `test`: Tests
   - `chore`: Maintenance

3. **User Input**
   If `$ARGUMENTS` provided, incorporate it into the message.

4. **Execute Commit**
   ```bash
   git commit -m "<message>"
   ```

5. **Verify**
   Show the commit result with `git log -1`
