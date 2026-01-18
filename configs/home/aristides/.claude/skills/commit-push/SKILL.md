---
name: commit-push
description: Makes git commits, handles merge conflicts and pushes them to the remote repository. Use when working with git commits or when the user mentions git add, commits, push or wants to save its current progress.
license: MIT
compatibility: Requires git, pre-commit, gh and access to the Internet.
metadata:
  author: ariguillegp
  version: "0.1"
---

# Commit and Push

This skill helps create well-formatted commits with conventional commit messages and push them to the remote repository.

## Instructions

### Step 1: Pre-commit Checks (unless `--no-verify`)
Run `pre-commit run -a` to ensure code quality. If checks fail, ask the user if they want to proceed anyway or fix issues first. Do not continue until you get feedback from the user if pre-commit checks fail.

### Step 2: Check Staged Files
Run `git status` to check which files are staged.

### Step 3: Stage Files if Needed
If no files are staged, automatically add all modified and new files with `git add`.

### Step 4: Analyze Changes
Run `git diff HEAD` to understand what changes are being committed and search across all the threads/sessions that have done work on the current git branch to make sure you have as much context as possible to craft a useful commit message.

### Step 5: Detect Multiple Logical Changes
Use `git hunks list` to see all individual hunks with their stable IDs. Analyze hunks to determine if multiple distinct logical changes are present. Consider splitting based on:
- **Different concerns**: Changes to unrelated parts of the codebase
- **Different types of changes**: Mixing features, fixes, refactoring, etc.
- **File patterns**: Changes to different types of files (e.g., source code vs documentation)
- **Logical grouping**: Changes that would be easier to understand or review separately
- **Size**: Very large changes that would be clearer if broken down

If multiple distinct changes are detected, use `git hunks add <hunk-id>` to stage related hunks together for each logical commit. Create separate commits for each logical group:

1. Reset any staged files: `git reset HEAD`
2. Stage first logical group: `git hunks add 'file:@-line,len+line,len' ...`
3. Commit with appropriate message
4. Repeat for remaining hunk groups

### Step 6: Create Commit Message
Use conventional commit [specification](https://www.conventionalcommits.org/en/v1.0.0/) format: `<type>: <description>`

Types:
- `feat`: A new feature
- `fix`: A bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc)
- `refactor`: Code changes that neither fix bugs nor add features
- `perf`: Performance improvements
- `test`: Adding or fixing tests
- `chore`: Changes to the build process, tools, etc.

### Step 7: Push to Remote
Push commits to origin using `git push`.

## Best Practices

- **Atomic commits**: Each commit should contain related changes that serve a single purpose
- **Present tense, imperative mood**: Write commit messages as commands (e.g., "add feature" not "added feature")
- **Concise first line**: Keep the first line under 72 characters

## Options

- `--no-verify`: Skip running pre-commit checks

## Examples

### Good Commit Messages
- feat: add user authentication system
- fix: resolve memory leak in rendering process
- docs: update API documentation with new endpoints
- refactor: simplify error handling logic in parser
- chore: improve developer tooling setup process
- test: add unit tests for new features

### Splitting Commits Example
When a single diff contains multiple logical changes:
1. feat: add new type definitions
2. docs: update documentation
3. chore: update dependencies
4. test: add unit tests for new features

### Hunk-Based Splitting Workflow
```bash
# List all hunks
$ git hunks list
src/auth.go:@-15,4+15,8
src/auth.go:@-42,3+46,5
README.md:@-1,5+1,10

# Stage auth-related hunks for first commit
$ git hunks add 'src/auth.go:@-15,4+15,8' 'src/auth.go:@-42,3+46,5'
$ git commit -m "feat: add token validation to auth module"

# Stage docs for second commit
$ git hunks add 'README.md:@-1,5+1,10'
$ git commit -m "docs: update setup instructions"
```
