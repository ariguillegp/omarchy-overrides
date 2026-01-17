---
name: code-review
description: Reviews Go code using native Go tooling (gofmt, go vet, go test, go build, govulncheck) plus manual review for idioms, tests, and security. Use when asked to review code, review a PR, review staged changes, review a diff, check code quality, or audit security of Go files.
---

# Code Review Skill

Comprehensive code review of Go code across four areas: general software engineering, Go idioms, test coverage, and security.

## Workflow

### Step 1: Determine What to Review

- **Staged changes (default)**: `git diff --cached`
- **Unstaged changes**: `git diff`
- **Specific files**: Review files explicitly mentioned
- **Compare branches**: `git diff main..HEAD`

If no input specified, ask: "Should I review staged changes, unstaged changes, or specific files?"

### Step 2: Run Native Go Tooling

Run before manual review. Report issues found.

```bash
gofmt -d .                # Formatting (use -w to fix)
go build ./...            # Compile errors
go test ./...             # Tests
go test -race ./...       # Race detection (if concurrency)
go vet ./...              # Static analysis
go mod tidy && go mod verify  # If go.mod/go.sum changed
govulncheck ./...         # Security (go install golang.org/x/vuln/cmd/govulncheck@latest)
```

### Step 3: Gather Context

1. Run the appropriate diff command
2. Read full files for context
3. Identify related test files (`*_test.go`)
4. Check if tests exist for new/changed functions

### Step 4: Perform Review

Analyze code across all four review areas. For each issue:
1. Assign severity
2. Note exact location
3. Describe the issue
4. Explain why it matters
5. Provide a fix

### Step 5: Output Report

Present findings in the format below, ordered by severity then by logical application order.

## Output Format

```markdown
# Code Review Report

## Summary
- **Files reviewed**: N
- **Critical issues**: N
- **High issues**: N
- **Medium issues**: N
- **Low issues**: N

## Findings

### [CRITICAL] Issue Title
- **Location**: `path/to/file.go:42`
- **Category**: Security / Go Best Practices / General / Testing
- **Issue**: Description of what's wrong
- **Why it matters**: Impact and risk
- **Fix**: 
  ```go
  // suggested code fix
  ```

## Application Order

Apply fixes in this order to avoid conflicts:
1. file.go:42 - Issue title
```

## Review Areas

### A: General Software Engineering

- **Code Clarity**: Unclear names, functions >30 lines, deep nesting >3 levels, magic numbers
- **DRY Violations**: Copy-pasted code, similar extractable logic
- **SOLID Principles**: Single responsibility, open/closed, Liskov substitution, interface segregation, dependency inversion
- **Documentation**: Missing doc comments on public APIs, outdated comments

### B: Go-Specific Best Practices

See [references/go-patterns.md](references/go-patterns.md) for version-aware code examples.

- **Go Version Awareness**: Check `go.mod` `go` directive and adjust advice accordingly
- **Idiomatic Go**: `if err != nil` pattern, composition over inheritance, defer for cleanup, early returns
- **Error Handling**: Wrapped errors with context, `errors.Is`, `errors.As`, `errors.Join` (Go 1.20+), no ignored errors
- **Goroutines/Channels**: Goroutine leaks, deadlocks, missing WaitGroup, race conditions (suggest `go test -race`)
- **Context Patterns**: Context passed to I/O, checked in loops, don't store context in structs, always defer cancel()
- **Sync Primitives**: WaitGroup.Add inside goroutine bug, copying mutex, locking order
- **Leaky Timers**: `time.After` in loops creates leaks, use `time.NewTimer`/`time.Ticker`
- **Slices/Maps**: nil vs empty slice semantics, map iteration order, retaining large backing arrays
- **Interface Design**: Minimal methods, defined where used, accept interfaces not concrete types
- **Package Organization**: No circular deps, focused packages, proper internal usage

### C: Test Coverage

See [references/test-patterns.md](references/test-patterns.md) for code examples.

- **Missing Tests**: New exported functions, changed logic paths, error conditions, edge cases (empty, nil, zero, max)
- **Test Quality**: Table-driven tests, descriptive names
- **Test Naming**: `TestType_Method_Scenario_Expected` pattern
- **Mocks/Stubs**: No real external services in unit tests, mocks verify behavior
- **Integration vs Unit**: Unit tests don't make network calls, critical paths have integration tests

### D: Security Analysis

See [references/security-patterns.md](references/security-patterns.md) for code examples.

- **Input Validation**: Parameterized queries
- **Injection**: SQL, command, template injection via string concatenation
- **Sensitive Data**: No logging secrets, no hardcoded credentials, no secrets in errors
- **Auth/Authz**: Missing auth checks, authorization bypass, session invalidation
- **Cryptography**: bcrypt/argon2 for passwords, no hardcoded IVs/salts, `crypto/rand` not `math/rand`
- **Race Conditions**: TOCTOU bugs, unprotected shared state
- **Unsafe Operations**: `unsafe` package, unvalidated type assertions
- **Path Traversal**: Validate paths stay within base directory
- **SSRF**: User-controlled URLs, no allowlist for external requests

## Severity Guidelines

| Severity | Criteria | Examples |
|----------|----------|----------|
| **Critical** | Security vulnerability, data loss risk, production crash | SQL injection, credential exposure, nil panic in hot path |
| **High** | Bug likely to cause issues, significant code smell | Goroutine leak, ignored error on critical path, race condition |
| **Medium** | Code quality issue, maintainability concern | DRY violation, missing tests, unclear naming |
| **Low** | Style preference, minor improvement | Comment wording, variable naming, minor optimization |
