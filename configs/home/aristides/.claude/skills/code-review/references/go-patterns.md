# Go Patterns Reference

## Error Handling

```go
// BAD: ignored error
result, _ := doSomething()

// BAD: no context
if err != nil {
    return err
}

// GOOD: wrapped with context
if err != nil {
    return fmt.Errorf("failed to process user %s: %w", userID, err)
}
```

## Error Sentinel Patterns

```go
// BAD: string comparison
if err.Error() == "not found" { ... }

// GOOD: sentinel errors with errors.Is
var ErrNotFound = errors.New("not found")

if errors.Is(err, ErrNotFound) { ... }

// GOOD: type checking with errors.As
var pathErr *os.PathError
if errors.As(err, &pathErr) {
    fmt.Println(pathErr.Path)
}

// GOOD: multiple errors (Go 1.20+)
return errors.Join(err1, err2)
```

## Context Patterns

```go
// BAD: missing cancel call (leak)
ctx, cancel := context.WithTimeout(parentCtx, time.Second)
doWork(ctx)

// GOOD: always defer cancel
ctx, cancel := context.WithTimeout(parentCtx, time.Second)
defer cancel()
doWork(ctx)

// BAD: storing context in struct
type Server struct {
    ctx context.Context  // anti-pattern
}

// GOOD: pass context as first parameter
func (s *Server) Handle(ctx context.Context, req Request) {}

// BAD: background context when parent exists
func Handle(ctx context.Context) {
    go doAsync(context.Background())  // loses cancellation
}

// GOOD: derive from parent
func Handle(ctx context.Context) {
    go doAsync(ctx)
}
```

## Sync Primitives

```go
// BAD: WaitGroup.Add inside goroutine (race)
var wg sync.WaitGroup
for i := 0; i < n; i++ {
    go func() {
        wg.Add(1)  // Too late! Main may exit before Add
        defer wg.Done()
        work()
    }()
}
wg.Wait()

// GOOD: Add before spawning
var wg sync.WaitGroup
for i := 0; i < n; i++ {
    wg.Add(1)
    go func() {
        defer wg.Done()
        work()
    }()
}
wg.Wait()

// BAD: copying mutex
type Counter struct {
    mu sync.Mutex
    n  int
}
c2 := c1  // Copies the mutex!

// GOOD: use pointer or embed carefully
```

## Leaky Timers

```go
// BAD: time.After in loop (leaks until fires)
for {
    select {
    case <-time.After(time.Second):  // New timer each iteration
        tick()
    case <-done:
        return
    }
}

// GOOD: reuse timer
timer := time.NewTimer(time.Second)
defer timer.Stop()
for {
    select {
    case <-timer.C:
        tick()
        timer.Reset(time.Second)
    case <-done:
        return
    }
}
```

## Common Pitfalls

### Defer in Loop

```go
// BAD: defer in loop
for _, f := range files {
    f, _ := os.Open(f)
    defer f.Close()  // Won't close until function returns
}
```

### Nil Pointer

```go
// BAD: nil pointer
var user *User
fmt.Println(user.Name)  // panic
```

### Range Variable Capture

**Note:** Go 1.22+ creates per-iteration variables for range loops, fixing this issue. Still relevant for:
- Pre-1.22 codebases (check `go.mod`)
- Classic `for i := 0; i < n; i++` loops
- Capturing other shared variables

```go
// BAD (pre-Go 1.22 or classic for loop)
for i := 0; i < len(values); i++ {
    go func() {
        process(values[i])  // i will be final value
    }()
}

// GOOD: capture explicitly
for i := 0; i < len(values); i++ {
    go func(i int) {
        process(values[i])
    }(i)
}
```
