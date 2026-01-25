# Ask User Question

Structured question-asking skill for gathering user input during task execution.

## Features

- Present multiple-choice questions with 2-4 options
- Support both single and multi-select modes
- Provide templates for common question types
- Guide clear option labeling and descriptions

## Installation

```bash
/plugin install ask-user-question@s-hiraoku/claude-code-harnesses-factory
```

## Usage

This skill is automatically triggered when Claude needs to:
- Gather user preferences or requirements
- Clarify ambiguous instructions
- Make decisions on implementation choices
- Offer directional choices to the user

## Question Templates

### Binary Choice
```
Header: "Confirm"
Question: "Do you want to proceed with [action]?"
```

### Implementation Choice
```
Header: "Approach"
Question: "Which implementation approach should be used?"
```

### Feature Selection (Multi-select)
```
Header: "Features"
Question: "Which features should be included?"
```

### Library Selection
```
Header: "Library"
Question: "Which library should be used for [purpose]?"
```

## Best Practices

- Place recommended option first with "(Recommended)" suffix
- Keep headers under 12 characters
- Provide 2-4 distinct options
- Include clear descriptions for each option

## License

MIT License
