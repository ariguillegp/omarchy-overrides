# Agent workflows

1. See @~/.config/agents/docs/*conventions.md for language/tool conventions I prefer.

2. All implementation tasks will be handled by subagents so they don't pollute the main agent's context. If this is not possible for any reason, I want you to tell me why this isn't possible and ask me for directions before you do anything else.

3. Design for testability using "functional core, imperative shell": keep pure business logic separate from code that does IO.

