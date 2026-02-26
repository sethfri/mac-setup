
# Path

path=(
  "$HOME/.rvm/gems/ruby-2.7.4/bin"
  "/usr/local/bin"
  "/usr/local/sbin"
  "/opt/homebrew/bin"
  "/opt/homebrew/sbin"
  "$HOME/bin"
  "/opt/local/bin"
  "/opt/local/sbin"
  "/usr/bin"
  "/bin"
  "/usr/sbin"
  "/sbin"
)

# Projects
alias ms="$HOME/Developer/mac-setup"
alias pmp="$HOME/Developer/private-mac-preferences"

# Git
alias gmt='git mergetool'
alias gm='git merge'
alias gcm='git commit -v'
alias gcmm='git commit -m'
alias gcmam='git commit -am'
alias gcma='git commit -a'
alias gsa='git stash apply'
alias gcp='git cherry-pick'
alias gco='git checkout'
alias gbr='git branch'
alias gcos='git checkout $(git branch | fzf)'
alias gpush='git push'
alias gpusht='git push --tags'
alias gpull='git pull'
alias gcpc='git cherry-pick --continue'
alias gs='git status'
alias grbc='git rebase --continue'
alias gl='git log'
alias gls='git log $(git branch | fzf)'
alias gd='git diff'
alias ga='git apply -3 -p3'
alias gcmamd='git commit --amend'
alias grl='git reflog'
alias grb='git rebase'
alias grba='git rebase --abort'
alias grhh='git reset --hard HEAD~1'
alias grh='git reset HEAD~1'
alias grst='git restore'
alias gwtr='git worktree remove'

alias python='python3'

function gr() { git rebase -i --autosquash HEAD~$1; }
function gra() { GIT_SEQUENCE_EDITOR=true git rebase -i --autosquash --autostash HEAD~$1; }

function gro() {
  NEW_BASE="$1"
  BRANCH="$2"
  NUM_COMMITS="$3"

  if [ -z $NUM_COMMITS ]; then
    NUM_COMMITS=1
  fi

  git rebase --onto "$NEW_BASE" "$BRANCH"~"$NUM_COMMITS" "$BRANCH"
}

function gwt() {
  local parent="$2"

  if [ -z $parent ]; then
    parent="main"
  fi

  git worktree add -b "$1" ../"$1" "$parent"
}

function gcmaf() {
    local target="HEAD"

    if [ -n "$1" ]; then
        target=$1
    fi

    git commit -a --fixup $target
}

function gcmf() {
    local target="HEAD"

    if [ -n "$1" ]; then
        target=$1
    fi

    git commit --fixup $target
}

function gpr() {
    if [ -n "$1" ]; then
        echo $1
        git checkout "$1"
    fi

    git pull -r
}

function fixref() {
  if [[ -z $1 ]]; then
    echo "Usage: $0 [branch_name]"
    return 1
  fi

  rm -rf .git/logs/refs/remotes/origin/"$1"
  rm -rf .git/refs/remotes/origin/"$1"
  git gc --prune=now
}

function gitfile() {
    git checkout $2 -- $1
}

# Ruby
alias be='bundle exec'
alias mine='open -a RubyMine'

# CocoaPods
alias pu='bundle exec pod update --repo-update'
alias nuke='rm -rf Pods/ && git clean -fff -dddd -x && dxdd && pod repo update && pik'

# Do a pod install without killing Xcode
function pi() {
  set -o pipefail

  POD_INSTALL_RESULT=$(bundle exec pod --ansi install "$@" | tee /dev/tty)

  if [[ $POD_INSTALL_RESULT == *"[!] CocoaPods could not find compatible versions for pod"* ]] \
    || [[ $POD_INSTALL_RESULT == *"[!] Unable to find a specification for"* ]]; then
    bundle exec pod install --repo-update "$@"
  fi

  if [[ $? -ne 0 ]]; then
    return 1
  fi
}

# Kill Xcode and then pod install
function pik() {
  pkill Xcode

  pi "$@"
}

function pio() {
  pik "$@" && xed .
}

# Backend
alias grad='./gradlew'
alias gb='./gradlew build'

# Claude
alias opus='claude --model opus'
alias sonnet='claude --model sonnet'

# Helpers
alias symbolicate="/Applications/Xcode.app/Contents/SharedFrameworks/DVTFoundation.framework/Versions/A/Resources/symbolicatecrash -v"
alias dorig='find . -iname \*.orig -delete'
alias ddd="rm -rf $HOME/Library/Developer/Xcode/DerivedData"
alias vs='open -a "Visual Studio Code" "$1"'
alias sz='source ~/.zshrc'

function fz() { $2 $($1 | fzf) }

# Get the list of commits that are about to be put in a PR so we can easily add a
# commit-by-commit PR description
function prl() {
    git log origin/main..HEAD --reverse --format='* %<(2)%B' | sed '/^$/d' | pbcopy
}

# zsh config

# automatically enter directories without cd
setopt AUTO_CD
# Make glob matching case insensitive
setopt NO_CASE_GLOB
# Add command autocorrection
setopt CORRECT
setopt CORRECT_ALL
# Do not start cycling through completion options on repeated tabs
setopt NO_AUTO_MENU

# Built in version of mv that can handle patterns
autoload -U zmv

autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^[[A" history-beginning-search-backward-end
bindkey "^[[B" history-beginning-search-forward-end

source "$HOME/Developer/mac-setup/config/zsh/colors.zsh"
source "$HOME/Developer/mac-setup/config/zsh/prompt.zsh"
source "$HOME/Developer/mac-setup/config/zsh/history.zsh"
source "$HOME/Developer/mac-setup/config/zsh/completion/completion.zsh"

# Completion

autoload -Uz compinit && compinit
autoload -U bashcompinit && bashcompinit

# Source Private Zsh

source "$HOME/Developer/private-mac-preferences/square-zshrc"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/homebrew/Caskroom/mambaforge/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/Caskroom/mambaforge/base/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/Caskroom/mambaforge/base/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/Caskroom/mambaforge/base/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


# bun completions
[ -s "/Users/sethfri/.bun/_bun" ] && source "/Users/sethfri/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
