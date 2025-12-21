---
name: git-workflow
description: Git workflow automation. Generates commit messages, manages branches, and handles pull requests. Use when working with git operations.
---

# Git Workflow

## Commit Message Generation

When generating commit messages:

1. Run `git diff --staged` to see changes
2. Analyze the scope and type of changes
3. Generate a message following Conventional Commits:

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

### Types
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style (formatting, semicolons)
- `refactor`: Code refactoring
- `perf`: Performance improvements
- `test`: Adding or updating tests
- `chore`: Build process, dependencies

### Examples

```bash
feat(auth): add login with OAuth2

- Implement Google OAuth2 provider
- Add session management
- Create login/logout endpoints

Closes #123
```

## Branch Management

### Branch Naming
```
<type>/<ticket-id>-<short-description>

# Examples
feature/PROJ-123-user-authentication
fix/PROJ-456-login-error
```

### Commands
```bash
# Create feature branch
git checkout -b feature/PROJ-123-description

# Update branch with main
git fetch origin
git rebase origin/main

# Clean up merged branches
git branch --merged | grep -v main | xargs git branch -d
```

## Pull Request Workflow

1. Push changes to remote
2. Create PR with descriptive title
3. Link related issues
4. Request reviews
5. Address feedback
6. Squash and merge

### PR Title Format
```
[PROJ-123] feat: Add user authentication
```
