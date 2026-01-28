# Jotai API Reference

## Table of Contents

1. [Core API](#core-api)
2. [Utils API](#utils-api)
3. [Store API](#store-api)
4. [Provider](#provider)

---

## Core API

### atom

状態の最小単位を定義。

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
| initialValue | `Value` | Primitive atomの初期値 |
| read | `(get: Getter) => Value` | 値を計算する関数 |
| write | `(get: Getter, set: Setter, ...args: Args) => Result` | 値を更新する関数 |

**Properties:**

- `debugLabel`: デバッグ用のラベル文字列
- `onMount`: atomが初めて購読されたときに呼ばれる関数

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

atomの値を読み書きするhook。

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

atomの値を読み取り専用で取得。

```typescript
function useAtomValue<Value>(atom: Atom<Value>): Awaited<Value>
```

```typescript
const count = useAtomValue(countAtom)
```

---

### useSetAtom

atomの値を更新する関数のみ取得。コンポーネントは値の変更で再レンダリングされない。

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

localStorage/sessionStorage永続化。

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

リセット可能なatom。

```typescript
import { atomWithReset, useResetAtom, RESET } from 'jotai/utils'

const formAtom = atomWithReset({ name: '', email: '' })

// コンポーネント内
const reset = useResetAtom(formAtom)
reset() // 初期値に戻る

// 派生atomでRESET使用
const derivedAtom = atom(
  (get) => get(formAtom),
  (get, set, value) => {
    set(formAtom, value === RESET ? RESET : value)
  }
)
```

---

### atomFamily

パラメータに基づいて動的にatomを生成・キャッシュ。

```typescript
import { atomFamily } from 'jotai/utils'

const todoFamily = atomFamily((id: string) =>
  atom({ id, text: '', completed: false })
)

// Methods
todoFamily('id')           // atomを取得
todoFamily.getParams()     // 全パラメータを取得
todoFamily.remove('id')    // キャッシュから削除
todoFamily.setShouldRemove((createdAt, param) => {
  return Date.now() - createdAt > 3600000
})
```

**メモリリーク対策必須**: `remove()`または`setShouldRemove()`で適切にクリーンアップ。

---

### selectAtom

大きなオブジェクトから一部を抽出。派生atomを優先。

```typescript
import { selectAtom } from 'jotai/utils'

const personAtom = atom({ name: 'John', age: 30 })
const nameAtom = selectAtom(personAtom, (person) => person.name)

// equalityFn指定
const addressAtom = selectAtom(
  personAtom,
  (person) => person.address,
  (a, b) => a.zip === b.zip
)
```

**注意**: 安定した参照が必要。useMemoまたはモジュールレベルで定義。

---

### splitAtom

配列の各要素を独立したatomとして管理。

```typescript
import { splitAtom } from 'jotai/utils'

const todosAtom = atom<Todo[]>([])
const todoAtomsAtom = splitAtom(todosAtom)

// keyExtractor指定
const todoAtomsAtom = splitAtom(todosAtom, (todo) => todo.id)

// Dispatch actions
const [todoAtoms, dispatch] = useAtom(todoAtomsAtom)
dispatch({ type: 'remove', atom: todoAtom })
dispatch({ type: 'insert', value: newTodo, before: todoAtom })
dispatch({ type: 'move', atom: todoAtom, before: anotherTodoAtom })
```

---

### atomWithDefault

デフォルト値を持つatom。nullをセットするとフォールバック。

```typescript
import { atomWithDefault } from 'jotai/utils'

const systemThemeAtom = atom('light')
const userThemeAtom = atomWithDefault((get) => get(systemThemeAtom))

// 使用
set(userThemeAtom, 'dark')  // ユーザー設定
set(userThemeAtom, null)    // システム設定にフォールバック
```

---

### focusAtom

Opticsを使った深いネストへのアクセス。

```typescript
import { focusAtom } from 'jotai-optics'

const userAtom = atom({ profile: { name: 'John' } })
const nameAtom = focusAtom(userAtom, (optic) => optic.prop('profile').prop('name'))
```

---

### loadable

Suspenseなしで非同期atomを扱う。

```typescript
import { loadable } from 'jotai/utils'

const asyncAtom = atom(async () => fetch('/api/data'))
const loadableAtom = loadable(asyncAtom)

// Returns: { state: 'loading' } | { state: 'hasData', data: T } | { state: 'hasError', error: Error }
const value = useAtomValue(loadableAtom)
```

---

### unwrap

非同期atomを同期的にアクセス。初期値を指定。

```typescript
import { unwrap } from 'jotai/utils'

const asyncAtom = atom(async () => 'data')
const unwrappedAtom = unwrap(asyncAtom, () => 'loading...')
```

---

## Store API

### createStore

独自のStoreを作成。

```typescript
import { createStore } from 'jotai'

const store = createStore()

// Methods
store.get(countAtom)                    // 値を取得
store.set(countAtom, 5)                 // 値を設定
store.sub(countAtom, () => {            // 購読
  console.log('changed:', store.get(countAtom))
})
```

---

### getDefaultStore

デフォルトのStoreを取得（Provider外で使用時）。

```typescript
import { getDefaultStore } from 'jotai'

const store = getDefaultStore()
store.set(countAtom, 10)
```

---

## Provider

React Context経由でStoreを提供。

```typescript
import { Provider } from 'jotai'

// 基本使用
<Provider>
  <App />
</Provider>

// カスタムStore使用
const myStore = createStore()
<Provider store={myStore}>
  <App />
</Provider>
```

---

### useStore

現在のStoreを取得。

```typescript
import { useStore } from 'jotai'

const store = useStore()
store.set(countAtom, 5)
```

---

### useHydrateAtoms

atomに初期値を注入（SSR/テスト用）。

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
