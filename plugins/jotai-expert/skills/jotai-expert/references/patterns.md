# Jotai Advanced Patterns

## Table of Contents

1. [Atom Composition](#atom-composition)
2. [State Machines](#state-machines)
3. [Form Management](#form-management)
4. [Optimistic Updates](#optimistic-updates)
5. [Derived Collections](#derived-collections)
6. [Error Handling](#error-handling)
7. [Middleware Pattern](#middleware-pattern)

---

## Atom Composition

### Default Value Override

```typescript
import { atomWithDefault } from 'jotai/utils'

const systemThemeAtom = atom('light')
const userThemeAtom = atomWithDefault((get) => get(systemThemeAtom))

// After setting a value to userThemeAtom, setting null falls back to default
```

### Utility Combination

When atomWith* utilities cannot be combined, implement manually with derived atoms.

```typescript
// Combining atomWithStorage and reducer pattern
const storageAtom = atomWithStorage('todos', [])

const todosAtom = atom(
  (get) => get(storageAtom),
  (get, set, action: TodoAction) => {
    const current = get(storageAtom)
    switch (action.type) {
      case 'add':
        set(storageAtom, [...current, action.todo])
        break
      case 'remove':
        set(storageAtom, current.filter((t) => t.id !== action.id))
        break
    }
  }
)
```

### Code Splitting with Action Atoms

```typescript
// base.ts
export const baseCountAtom = atom(0)

// increment.ts (lazy loaded)
export const incrementAtom = atom(null, async (get, set) => {
  const { baseCountAtom } = await import('./base')
  set(baseCountAtom, get(baseCountAtom) + 1)
})
```

---

## State Machines

### Simple State Machine

```typescript
type State = 'idle' | 'loading' | 'success' | 'error'
type Event = { type: 'FETCH' } | { type: 'SUCCESS' } | { type: 'ERROR' }

const stateAtom = atom<State>('idle')

const transitionAtom = atom(null, (get, set, event: Event) => {
  const current = get(stateAtom)

  const transitions: Record<State, Partial<Record<Event['type'], State>>> = {
    idle: { FETCH: 'loading' },
    loading: { SUCCESS: 'success', ERROR: 'error' },
    success: { FETCH: 'loading' },
    error: { FETCH: 'loading' },
  }

  const next = transitions[current][event.type]
  if (next) set(stateAtom, next)
})
```

---

## Form Management

### Form with Validation

```typescript
interface FormState {
  values: { name: string; email: string }
  errors: { name?: string; email?: string }
  touched: { name: boolean; email: boolean }
}

const formAtom = atomWithReset<FormState>({
  values: { name: '', email: '' },
  errors: {},
  touched: { name: false, email: false },
})

const setFieldAtom = atom(
  null,
  (get, set, field: 'name' | 'email', value: string) => {
    const form = get(formAtom)
    const newValues = { ...form.values, [field]: value }
    const newErrors = validate(newValues)

    set(formAtom, {
      ...form,
      values: newValues,
      errors: newErrors,
      touched: { ...form.touched, [field]: true },
    })
  }
)

const isValidAtom = atom((get) => {
  const { errors } = get(formAtom)
  return Object.keys(errors).length === 0
})
```

### Field-level Atoms

```typescript
const formValuesAtom = atom({ name: '', email: '' })

const fieldAtom = (field: keyof typeof formValuesAtom) =>
  atom(
    (get) => get(formValuesAtom)[field],
    (get, set, value: string) => {
      set(formValuesAtom, { ...get(formValuesAtom), [field]: value })
    }
  )

const nameAtom = fieldAtom('name')
const emailAtom = fieldAtom('email')
```

---

## Optimistic Updates

```typescript
interface Todo {
  id: string
  text: string
  completed: boolean
}

const todosAtom = atom<Todo[]>([])
const pendingUpdatesAtom = atom<Map<string, Partial<Todo>>>(new Map())

// Optimistic view
const optimisticTodosAtom = atom((get) => {
  const todos = get(todosAtom)
  const pending = get(pendingUpdatesAtom)

  return todos.map((todo) => {
    const update = pending.get(todo.id)
    return update ? { ...todo, ...update } : todo
  })
})

// Update with rollback
const updateTodoAtom = atom(
  null,
  async (get, set, id: string, update: Partial<Todo>) => {
    // Optimistic update
    const pending = new Map(get(pendingUpdatesAtom))
    pending.set(id, update)
    set(pendingUpdatesAtom, pending)

    try {
      await api.updateTodo(id, update)

      // Apply real update
      set(todosAtom, (todos) =>
        todos.map((t) => (t.id === id ? { ...t, ...update } : t))
      )
    } catch (error) {
      // Rollback handled by removing from pending
    } finally {
      // Remove from pending
      const newPending = new Map(get(pendingUpdatesAtom))
      newPending.delete(id)
      set(pendingUpdatesAtom, newPending)
    }
  }
)
```

---

## Derived Collections

### Filtered and Sorted Lists

```typescript
type SortOrder = 'asc' | 'desc'
type FilterStatus = 'all' | 'active' | 'completed'

const todosAtom = atom<Todo[]>([])
const sortOrderAtom = atom<SortOrder>('asc')
const filterStatusAtom = atom<FilterStatus>('all')

const filteredTodosAtom = atom((get) => {
  const todos = get(todosAtom)
  const filter = get(filterStatusAtom)

  if (filter === 'all') return todos
  return todos.filter((t) =>
    filter === 'completed' ? t.completed : !t.completed
  )
})

const sortedTodosAtom = atom((get) => {
  const todos = get(filteredTodosAtom)
  const order = get(sortOrderAtom)

  return [...todos].sort((a, b) => {
    const comparison = a.text.localeCompare(b.text)
    return order === 'asc' ? comparison : -comparison
  })
})

// Statistics
const statsAtom = atom((get) => {
  const todos = get(todosAtom)
  return {
    total: todos.length,
    completed: todos.filter((t) => t.completed).length,
    active: todos.filter((t) => !t.completed).length,
  }
})
```

---

## Error Handling

### Error Boundary Integration

```typescript
const dataAtom = atom(async () => {
  const response = await fetch('/api/data')
  if (!response.ok) {
    throw new Error(`HTTP ${response.status}`)
  }
  return response.json()
})

// Error state atom
const errorAtom = atom<Error | null>(null)

const safeDataAtom = atom(
  async (get) => {
    try {
      return await get(dataAtom)
    } catch (error) {
      throw error // Re-throw for Error Boundary
    }
  },
  (get, set, _arg, error: Error) => {
    set(errorAtom, error)
  }
)
```

### Retry Pattern

```typescript
const fetchWithRetryAtom = atom(null, async (get, set, maxRetries = 3) => {
  let lastError: Error | null = null

  for (let i = 0; i < maxRetries; i++) {
    try {
      const data = await fetch('/api/data').then((r) => r.json())
      set(dataAtom, data)
      return
    } catch (error) {
      lastError = error as Error
      await new Promise((r) => setTimeout(r, 1000 * Math.pow(2, i)))
    }
  }

  set(errorAtom, lastError)
})
```

---

## Middleware Pattern

### Logging Middleware

```typescript
const withLogging = <T>(baseAtom: PrimitiveAtom<T>, name: string) =>
  atom(
    (get) => get(baseAtom),
    (get, set, newValue: T) => {
      const prev = get(baseAtom)
      console.log(`[${name}] ${JSON.stringify(prev)} -> ${JSON.stringify(newValue)}`)
      set(baseAtom, newValue)
    }
  )

const countAtom = atom(0)
const loggedCountAtom = withLogging(countAtom, 'count')
```

### Debounce Middleware

```typescript
const withDebounce = <T>(
  baseAtom: PrimitiveAtom<T>,
  delay: number
) => {
  let timeoutId: ReturnType<typeof setTimeout> | null = null

  return atom(
    (get) => get(baseAtom),
    (get, set, newValue: T) => {
      if (timeoutId) clearTimeout(timeoutId)

      timeoutId = setTimeout(() => {
        set(baseAtom, newValue)
        timeoutId = null
      }, delay)
    }
  )
}

const searchAtom = atom('')
const debouncedSearchAtom = withDebounce(searchAtom, 300)
```

### Persistence Middleware

```typescript
const withPersistence = <T>(
  baseAtom: PrimitiveAtom<T>,
  key: string
) => {
  const persistedAtom = atom(
    (get) => get(baseAtom),
    (get, set, newValue: T) => {
      set(baseAtom, newValue)
      localStorage.setItem(key, JSON.stringify(newValue))
    }
  )

  persistedAtom.onMount = (setAtom) => {
    const stored = localStorage.getItem(key)
    if (stored) {
      setAtom(JSON.parse(stored))
    }
  }

  return persistedAtom
}
```
