# Security Patterns Reference

## Input Validation / SQL Injection

```go
// BAD: String concatenation
db.Query("SELECT * FROM users WHERE id = " + userInput)

// GOOD: Parameterized (placeholder style is driver-dependent)
db.QueryContext(ctx, "SELECT * FROM users WHERE id = ?", userInput)    // MySQL
db.QueryContext(ctx, "SELECT * FROM users WHERE id = $1", userInput)   // PostgreSQL

// GOOD: Always use context for timeout/cancellation
ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
defer cancel()
db.QueryContext(ctx, "SELECT ...", args...)
```

## Sensitive Data

```go
// BAD: Logging secrets
log.Printf("Connecting with password: %s", password)

// BAD: Hardcoded credentials
const apiKey = "sk-live-abc123"

// BAD: Secrets in error messages
return fmt.Errorf("auth failed for token: %s", token)
```

## Unsafe Operations

```go
// CRITICAL: unsafe package usage
import "unsafe"

// HIGH: Unvalidated type assertions
val := data.(string)  // Can panic

// GOOD: Safe assertion
val, ok := data.(string)
if !ok {
    return errors.New("expected string")
}
```

## Path Traversal

```go
// BAD: User controls path
filePath := filepath.Join(baseDir, userInput)
// userInput could be "../../../etc/passwd"

// BAD: HasPrefix footgun ("/tmp/foo" matches "/tmp/foobar")
cleanPath := filepath.Clean(filepath.Join(baseDir, userInput))
if !strings.HasPrefix(cleanPath, baseDir) {
    return errors.New("path traversal detected")
}

// GOOD: Use filepath.Rel for robust check
absBase, _ := filepath.Abs(baseDir)
absPath, _ := filepath.Abs(filepath.Join(baseDir, userInput))
rel, err := filepath.Rel(absBase, absPath)
if err != nil || strings.HasPrefix(rel, ".."+string(os.PathSeparator)) || rel == ".." {
    return errors.New("path traversal detected")
}
```
