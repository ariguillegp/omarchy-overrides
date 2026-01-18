# Test Patterns Reference

## Table-Driven Tests

```go
// BAD: Single assertion, no context
func TestProcess(t *testing.T) {
    result := Process(input)
    if result != expected {
        t.Fail()
    }
}

// GOOD: Table-driven with clear names
func TestProcess(t *testing.T) {
    tests := []struct {
        name     string
        input    Input
        expected Output
        wantErr  bool
    }{
        {
            name:     "valid input returns expected output",
            input:    validInput,
            expected: expectedOutput,
        },
        {
            name:    "empty input returns error",
            input:   Input{},
            wantErr: true,
        },
    }
    
    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            got, err := Process(tt.input)
            if (err != nil) != tt.wantErr {
                t.Errorf("Process() error = %v, wantErr %v", err, tt.wantErr)
                return
            }
            if !reflect.DeepEqual(got, tt.expected) {
                t.Errorf("Process() = %v, want %v", got, tt.expected)
            }
        })
    }
}
```

## Test Naming

Test names should describe the scenario:
- `TestUserService_Create_WithDuplicateEmail_ReturnsError`
- Subtests should be descriptive
