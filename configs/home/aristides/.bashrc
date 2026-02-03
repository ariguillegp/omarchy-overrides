# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
source ~/.local/share/omarchy/default/bash/rc

# Add your own exports, aliases, and functions here.
#
# shell autocompletion for kubectl commands
source <(kubectl completion bash)

# Make an alias for invoking commands you use constantly
alias a='amp'
alias c='claude'
alias v='nvim'
alias oc='opencode'
alias l='ls'
alias k='kubectl'

export PATH="$HOME/.local/bin:$PATH"

# Active mise environments automatically
eval "$(mise activate bash)"

# Launch solo project picker with Ctrl-F
bind -x '"\C-f": "solo"'
