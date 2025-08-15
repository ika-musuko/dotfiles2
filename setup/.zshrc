#####
# prompt
function git_dirty_info {
  [[ $(git status --porcelain 2> /dev/null) ]] \
    && echo "*" \
}

function git_branch_info {
  git_branch=$(git branch 2>/dev/null | sed -n '/\* /s///p')
  git_dirty=$(git_dirty_info)
  color=$([[ -n $git_dirty ]] && echo "%F{red}" || echo "%F{green}")
  [[ -n $git_branch ]] \
    && echo " ${color}(${git_branch}${git_dirty})"
}

function virtualenv_info() {
    if [[ -n "$VIRTUAL_ENV" ]]; then
        echo "(%F{white}$(basename $VIRTUAL_ENV)%f) "
    fi
}

setopt prompt_subst
prompt() {
  PS1="$(virtualenv_info)%F{10}%D{%H:%M%:%S} %~$(git_branch_info) %F{yellow}\$ %F{reset}"
}
precmd_functions+=(prompt)


# ZSH settings
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=10000000
export SAVEHIST=10000000
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
setopt HIST_BEEP                 # Beep when accessing nonexistent history.

zstyle ':completion:*' menu select
bindkey '^[[Z' reverse-menu-complete
autoload -Uz compinit; compinit

# zsh autocomplete with arrow keys
autoload -Uz up-line-or-beginning-search
autoload -Uz down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search

# vim bindings
bindkey -v
