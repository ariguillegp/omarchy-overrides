# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
source ~/.local/share/omarchy/default/bash/rc

# Add your own exports, aliases, and functions here.
# shell autocompletion for kubectl commands
source <(kubectl completion bash)

# Make an alias for invoking commands you use constantly
alias a='amp'
alias c='claude'
alias o='opencode'
alias x='codex'
alias v='nvim'
alias l='ls'
alias k='kubectl'

# local path used for custom installations
export PATH="$HOME/.local/bin:$PATH"

# Added by git-ai installer on Thu Mar  5 06:18:46 PM EST 2026
export PATH="$HOME/.git-ai/bin:$PATH"

# Launch rv project picker with Ctrl-F
bind -x '"\C-f": "rv"'


# Added by git-ai installer on Tue Mar 10 11:47:04 PM EDT 2026
export PATH="/home/aristides/.git-ai/bin:$PATH"
