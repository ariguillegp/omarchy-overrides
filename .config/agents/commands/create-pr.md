# Create Pull Request

This guide explains how to create pull requests using the GitHub CLI in our project.

## Prerequisites

1. Install GitHub CLI if you haven't already:

   ```bash
   sudo pacman -S github-cli
   ```

2. Authenticate with GitHub:

   ```bash
   gh auth login
   ```

3. Get the current branch:

   ```bash
   git branch --show-current
   ```

## Creating a New Pull Request

1. First, prepare your PR description with a concise summary that clearly explains the changes made across all the threads where work was done in the current branch.

2. Use always the `gh pr create --draft` command to create a new pull request in draft mode:

   ```bash
   # Basic command structure
   gh pr create --draft --title "(scope): Your descriptive title" --body "Your PR description" --base main 
   ```

   For more complex PR descriptions with proper formatting, use the `--body-file` option with the exact PR template structure:

   ```bash
   # Create PR with proper template structure
   gh pr create --draft --title "(scope): Your descriptive title" --body-file body-file.md --base main

3. Always assign the PRs to my GitHub user.
4. Always attach labels to the PR that are relevant to the topic at hand. If the labels exist use them, if they don't exit create them.
   ```

## Best Practices

1. **Language**: Always use English for PR titles and descriptions

2. **PR Title Format**: Use conventional commit [format](https://www.conventionalcommits.org/en/v1.0.0/)

   - Examples:
     - `(supabase): Add staging remote configuration`
     - `(auth): Fix login redirect issue`
     - `(readme): Update installation instructions`

3. **Draft PRs**: Start as draft when the work is in progress

### Common Mistakes to Avoid

1. **Using Non-English Text**: All PR content must be in English
2. **Forget assignee**: All PRs must be assigned to my GitHub user
3. **Forget labels**: All PRs must have labels according to their topic.

## Additional GitHub CLI PR Commands

Here are some additional useful GitHub CLI commands for managing PRs:

```bash
# List your open pull requests
gh pr list --author "@me"

# Check PR status
gh pr status

# View a specific PR
gh pr view <PR-NUMBER>

# Check out a PR branch locally
gh pr checkout <PR-NUMBER>

# Convert a draft PR to ready for review
gh pr ready <PR-NUMBER>

# Add reviewers to a PR
gh pr edit <PR-NUMBER> --add-reviewer username1,username2

# Merge a PR
gh pr merge <PR-NUMBER> --squash
```

