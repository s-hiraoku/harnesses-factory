# Jotai API Reference

## Table of Contents

1. [Core API](#core-api)
2. [Utils API](#utils-api)
3. [Store API](#store-api)
4. [Provider](#provider)

---

## Core API

### atom

Defines the smallest unit of state.

```typescript
// Signature
function atom<Value>(initialValue: Value): PrimitiveAtom<Value>
function atom<Value>(read: Read<Value>): Atom<Value>
function atom<Value, Args extends unknown[], Result>(
  read: Read<Value>,
  write: Write<Args, Result>
): WritableAtom<Value, Args, Result>
function atom<Value, Args extends unknown[], Result>(
  read: null,
  write: Write<Args, Result>
): WritableAtom<Value, Args, Result>
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| initialValue | `Value` | Initial value for primitive atom |
| read | `(get: Getter) => Value` | Function to compute the value |
| write | `(get: Getter, set: Setter, ...args: Args) => Result` | Function to update the value |

**Properties:**

- `debugLabel`: Label string for debugging
- `onMount`: Function called when the atom is first subscribed

```typescript
const countAtom = atom(0)
countAtom.debugLabel = 'count'
countAtom.onMount = (setAtom) => {
  console.log('Mounted')
  return () => console.log('Unmounted')
}
```

---

### useAtom

Hook to read and write atom values.

```typescript
function useAtom<Value, Args extends unknown[], Result>(
  atom: WritableAtom<Value, Args, Result>
): [Awaited<Value>, (...args: Args) => Result]
```

```typescript
const [count, setCount] = useAtom(countAtom)
```

---

### useAtomValue

Get atom value as read-only.

```typescript
function useAtomValue<Value>(atom: Atom<Value>): Awaited<Value>
```

```typescript
const count = useAtomValue(countAtom)
```

---

### useSetAtom

Get only the function to update atom value. Component does not re-render on value changes.

```typescript
function useSetAtom<Value, Args extends unknown[], Result>(
  atom: WritableAtom<Value, Args, Result>
): (...args: Args) => Result
```

```typescript
const setCount = useSetAtom(countAtom)
setCount(5)
```

---

## Utils API

### atomWithStorage

localStorage/sessionStorage persistence.

```typescript
import { atomWithStorage, createJSONStorage } from 'jotai/utils'

// localStorage (default)
const themeAtom = atomWithStorage('theme', 'light')

// sessionStorage
const sessionAtom = atomWithStorage(
  'session',
  null,
  createJSONStorage(() => sessionStorage)
)

// AsyncStorage (React Native)
const asyncAtom = atomWithStorage('key', value, asyncStorage)
```

---

### atomWithReset / useResetAtom / RESET

Resettable atom.

```typescript
import { atomWithReset, useResetAtom, RESET } from 'jotai/utils'

const formAtom = atomWithReset({ name: '', email: '' })

// Inside component
const reset = useResetAtom(formAtom)
reset() // Resets to initial value

// Using RESET in derived atom
const derivedAtom = atom(
  (get) => get(formAtom),
  (get, set, value) => {
    set(formAtom, value === RESET ? RESET : value)
  }
)
```

---

### atomFamily

Dynamically generate and cache atoms based on parameters.

```typescript
import { atomFamily } from 'jotai/utils'

const todoFamily = atomFamily((id: string) =>
  atom({ id, text: '', completed: false })
)

// Methods
todoFamily('id')           // Get atom
todoFamily.getParams()     // Get all parameters
todoFamily.remove('id')    // Remove from cache
todoFamily.setShouldRemove((createdAt, param) => {
  return Date.now() - createdAt > 3600000
})
```

**Memory leak prevention required**: Properly cleanup with `remove()` or `setShouldRemove()`.

---

### selectAtom

Extract a portion from a large object. Prefer derived atoms.

```typescript
import { selectAtom } from 'jotai/utils'

const personAtom = atom({ name: 'John', age: 30 })
const nameAtom = selectAtom(personAtom, (person) => person.name)

// Specify equalityFn
const addressAtom = selectAtom(
  personAtom,
  (person) => person.address,
  (a, b) => a.zip === b.zip
)
```

**Note**: Stable reference required. Define with useMemo or at module level.

---

### splitAtom

Manage each array element as an independent atom.

```typescript
import { splitAtom } from 'jotai/utils'

const todosAtom = atom<Todo[]>([])
const todoAtomsAtom = splitAtom(todosAtom)

// Specify keyExtractor
const todoAtomsAtom = splitAtom(todosAtom, (todo) => todo.id)

// Dispatch actions
const [todoAtoms, dispatch] = useAtom(todoAtomsAtom)
dispatch({ type: 'remove', atom: todoAtom })
dispatch({ type: 'insert', value: newTodo, before: todoAtom })
dispatch({ type: 'move', atom: todoAtom, before: anotherTodoAtom })
```

---

### atomWithDefault

Atom with default value. Falls back when set to null.

```typescript
import { atomWithDefault } from 'jotai/utils'

const systemThemeAtom = atom('light')
const userThemeAtom = atomWithDefault((get) => get(systemThemeAtom))

// Usage
set(userThemeAtom, 'dark')  // User setting
set(userThemeAtom, null)    // Fallback to system setting
```

---

### focusAtom

Access deeply nested values using Optics.

```typescript
import { focusAtom } from 'jotai-optics'

const userAtom = atom({ profile: { name: 'John' } })
const nameAtom = focusAtom(userAtom, (optic) => optic.prop('profile').prop('name'))
```

---

### loadable

Handle async atoms without Suspense.

```typescript
import { loadable } from 'jotai/utils'

const asyncAtom = atom(async () => fetch('/api/data'))
const loadableAtom = loadable(asyncAtom)

// Returns: { state: 'loading' } | { state: 'hasData', data: T } | { state: 'hasError', error: Error }
const value = useAtomValue(loadableAtom)
```

---

### unwrap

Access async atom synchronously. Specify initial value.

```typescript
import { unwrap } from 'jotai/utils'

const asyncAtom = atom(async () => 'data')
const unwrappedAtom = unwrap(asyncAtom, () => 'loading...')
```

---

## Store API

### createStore

Create a custom Store.

```typescript
import { createStore } from 'jotai'

const store = createStore()

// Methods
store.get(countAtom)                    // Get value
store.set(countAtom, 5)                 // Set value
store.sub(countAtom, () => {            // Subscribe
  console.log('changed:', store.get(countAtom))
})
```

---

### getDefaultStore

Get the default Store (when used outside Provider).

```typescript
import { getDefaultStore } from 'jotai'

const store = getDefaultStore()
store.set(countAtom, 10)
```

---

## Provider

Provide Store via React Context.

```typescript
import { Provider } from 'jotai'

// Basic usage
<Provider>
  <App />
</Provider>

// Using custom Store
const myStore = createStore()
<Provider store={myStore}>
  <App />
</Provider>
```

---

### useStore

Get the current Store.

```typescript
import { useStore } from 'jotai'

const store = useStore()
store.set(countAtom, 5)
```

---

### useHydrateAtoms

Inject initial values into atoms (for SSR/testing).

```typescript
import { useHydrateAtoms } from 'jotai/utils'

function App() {
  useHydrateAtoms([
    [countAtom, 10],
    [userAtom, { name: 'John' }],
  ])
  return <Counter />
}
```
