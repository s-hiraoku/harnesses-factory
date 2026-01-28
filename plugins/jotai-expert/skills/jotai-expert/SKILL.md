---
name: jotai-expert
description: |
  Expert skill for the Jotai state management library. Use when implementing atom-based state management in React applications. Use this skill for:
  (1) Jotai atom design and implementation
  (2) Derived atoms, async atoms, atomFamily implementation
  (3) Refactoring based on Jotai best practices
  (4) Performance optimization (selectAtom, splitAtom, etc.)
  (5) Persistence (localStorage/sessionStorage integration)
  (6) TypeScript type definitions
  (7) Test implementation
  Triggered when users ask questions or request implementations related to "Jotai", "atom", or "state management".
---

# Jotai Expert

Implementation guide for React state management using Jotai.

## Core Concepts

### Atom

The smallest unit of state. Does not hold value itself; stored in the Store.

```typescript
// Primitive atom
const countAtom = atom(0)
const nameAtom = atom('')

// Derived read-only atom
const doubleAtom = atom((get) => get(countAtom) * 2)

// Derived read-write atom
const countWithLabelAtom = atom(
  (get) => `Count: ${get(countAtom)}`,
  (get, set, newValue: number) => set(countAtom, newValue)
)

// Write-only atom (action atom)
const incrementAtom = atom(null, (get, set) => {
  set(countAtom, get(countAtom) + 1)
})
```

### Hooks

```typescript
// Read and write
const [value, setValue] = useAtom(countAtom)

// Read only
const value = useAtomValue(countAtom)

// Write only
const setValue = useSetAtom(countAtom)
```

## Implementation Patterns

### Pattern 1: Feature Module

```typescript
// atoms/user.ts
const baseUserAtom = atom<User | null>(null)

// Public read-only atom
export const userAtom = atom((get) => get(baseUserAtom))

// Actions
export const setUserAtom = atom(null, (get, set, user: User) => {
  set(baseUserAtom, user)
})

export const clearUserAtom = atom(null, (get, set) => {
  set(baseUserAtom, null)
})
```

### Pattern 2: Async Data Fetching

```typescript
const userIdAtom = atom<number | null>(null)

// Async atom that integrates with Suspense
const userDataAtom = atom(async (get) => {
  const userId = get(userIdAtom)
  if (!userId) return null
  const response = await fetch(`/api/users/${userId}`)
  return response.json()
})

// Component
function UserProfile() {
  const userData = useAtomValue(userDataAtom)
  return <div>{userData?.name}</div>
}

// Wrap with Suspense
<Suspense fallback={<Loading />}>
  <UserProfile />
</Suspense>
```

### Pattern 3: atomFamily

Dynamically generate and cache atoms. Memory leak prevention is essential.

```typescript
const todoFamily = atomFamily((id: string) =>
  atom({ id, text: '', completed: false })
)

// Usage
const todoAtom = todoFamily('todo-1')

// Cleanup
todoFamily.remove('todo-1')

// Set auto-removal rules
todoFamily.setShouldRemove((createdAt, param) => {
  return Date.now() - createdAt > 60 * 60 * 1000 // Remove after 1 hour
})
```

### Pattern 4: Persistence

```typescript
import { atomWithStorage } from 'jotai/utils'

// localStorage persistence
const themeAtom = atomWithStorage('theme', 'light')

// sessionStorage persistence
import { createJSONStorage } from 'jotai/utils'
const sessionAtom = atomWithStorage(
  'session',
  null,
  createJSONStorage(() => sessionStorage)
)
```

### Pattern 5: Reset

```typescript
import { atomWithReset, useResetAtom, RESET } from 'jotai/utils'

const formAtom = atomWithReset({ name: '', email: '' })

// Inside component
const resetForm = useResetAtom(formAtom)
resetForm() // Resets to initial value

// Using RESET symbol in derived atom
const derivedAtom = atom(
  (get) => get(formAtom),
  (get, set, newValue) => {
    set(formAtom, newValue === RESET ? RESET : newValue)
  }
)
```

## Performance Optimization

### selectAtom

Extract only a portion from a large object. Prefer derived atoms; use only when necessary.

```typescript
import { selectAtom } from 'jotai/utils'

const personAtom = atom({ name: 'John', age: 30, address: {...} })

// Subscribe only to name
const nameAtom = selectAtom(personAtom, (person) => person.name)

// Stable reference required (useMemo or external definition)
const stableNameAtom = useMemo(
  () => selectAtom(personAtom, (p) => p.name),
  []
)
```

### splitAtom

Manage each array element as an independent atom.

```typescript
import { splitAtom } from 'jotai/utils'

const todosAtom = atom<Todo[]>([])
const todoAtomsAtom = splitAtom(todosAtom)

function TodoList() {
  const [todoAtoms, dispatch] = useAtom(todoAtomsAtom)

  return (
    <>
      {todoAtoms.map((todoAtom) => (
        <TodoItem
          key={`${todoAtom}`}
          todoAtom={todoAtom}
          onRemove={() => dispatch({ type: 'remove', atom: todoAtom })}
        />
      ))}
    </>
  )
}
```

## TypeScript

```typescript
// Leverage type inference (explicit type definitions often unnecessary)
const countAtom = atom(0) // PrimitiveAtom<number>

// When explicit type definition is needed
const userAtom = atom<User | null>(null)

// Write-only atom type
const actionAtom = atom<null, [string, number], void>(
  null,
  (get, set, str, num) => { ... }
)

// Type extraction
type CountValue = ExtractAtomValue<typeof countAtom> // number
```

## Testing

```typescript
import { render, screen } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { Provider } from 'jotai'
import { useHydrateAtoms } from 'jotai/utils'

// Helper to inject initial values
function HydrateAtoms({ initialValues, children }) {
  useHydrateAtoms(initialValues)
  return children
}

function TestProvider({ initialValues, children }) {
  return (
    <Provider>
      <HydrateAtoms initialValues={initialValues}>
        {children}
      </HydrateAtoms>
    </Provider>
  )
}

// Test
test('increments counter', async () => {
  render(
    <TestProvider initialValues={[[countAtom, 5]]}>
      <Counter />
    </TestProvider>
  )

  await userEvent.click(screen.getByRole('button'))
  expect(screen.getByText('6')).toBeInTheDocument()
})
```

## Debugging

```typescript
// Add debug label
countAtom.debugLabel = 'count'

// Check all atoms in Provider with useAtomsDebugValue
import { useAtomsDebugValue } from 'jotai-devtools'
function DebugObserver() {
  useAtomsDebugValue()
  return null
}

// Redux DevTools integration
import { useAtomDevtools } from 'jotai-devtools'
useAtomDevtools(countAtom, { name: 'count' })
```

## Best Practices

1. **Atom granularity**: Split into small, reusable units
2. **Encapsulation**: Hide base atoms and export only derived atoms
3. **Action atoms**: Separate complex update logic into write-only atoms
4. **Async handling**: Properly place Suspense and Error Boundaries
5. **atomFamily**: Use `remove()` or `setShouldRemove()` to prevent memory leaks
6. **TypeScript**: Leverage type inference; define types explicitly only when necessary
7. **Testing**: Write tests that closely resemble user interactions

## References

For more details, see:
- [patterns.md](references/patterns.md): Advanced implementation patterns
- [api.md](references/api.md): API detailed reference
