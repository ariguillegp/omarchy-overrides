---
globs:
  - '**/*.go'
---

Follow these Go conventions:

Nomenclature:
1. Always use camelcase for all identifiers.
2. Acronyms must be all uppercase unless they are at the beginning of an identifier.
3. Default to always make identifiers private, i.e. the first letter is lowercase unless you are absolutely sure they must be public because they need to be used by another package.
4. User resource identifiers that are short, concise and reveal their purpose clearly.

Function signatures
1. Default to always make identifiers private, i.e. the first letter is lowercase unless you are absolutely sure they must be public because they need to be used by another package.
2. If you need to pass a context as an argument to the function, always use `ctx` as the name of the argument and always make it the first argument, for example: `func req(ctx context.Context, x int) {}`
3. If you need to return an error it must be the last value returned, for example: `func div(x, y int) (int, error) {}`
4. Prefer to receive an interface as an argument and return a concrete value.

Comments:
1. Code comments must not repeat what's clear and explicit in the source code, instead they must provide relevant context as to why certain functionality is the way it is, pros and cons and maybe future plans to iterate on it.

File names:
1. Do not use helper, utils or anything of that nature as file names. It should be very clear to me what I'm gonna see within certain file name just by reading its name.

Concurrency:
1. When you are using wait groups, do not use the old notation that requires wg.Add() and wg.Done() to be explicit. Instead use the new notation that does `wg.Go(func(){})` and implicitly does the same.

Validations:
ALWAYS run the following steps after go files are changed to make sure at least the baseline concerns are covered:
1. Run `go fmt` to apply the standard formatting. 
2. Run `go vet` to apply common linters.
3. Run `go test` to make sure at least unit tests are all passing.
