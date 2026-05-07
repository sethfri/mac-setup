# let's load colors into our environment, then set them
autoload -U colors; colors

export CLICOLOR=1
 
# The variables are wrapped in %{%}. This should be the case for every
# variable that does not contain space.
for COLOR in RED GREEN YELLOW BLUE WHITE BLACK MAGENTA CYAN; do
  eval PR_$COLOR='%{$fg_no_bold[${(L)COLOR}]%}'
  eval PR_BOLD_$COLOR='%{$fg_bold[${(L)COLOR}]%}'
done
 
export PR_RED PR_GREEN PR_YELLOW PR_BLUE PR_WHITE PR_BLACK PR_MAGENTA PR_CYAN
export PR_BOLD_RED PR_BOLD_GREEN PR_BOLD_YELLOW PR_BOLD_BLUE
export PR_BOLD_WHITE PR_BOLD_BLACK PR_BOLD_MAGENTA PR_BOLD_CYAN
 
# Clear LSCOLORS
unset LSCOLORS
 
# Main change, you can see directories on a dark background
export LSCOLORS=gxfxcxdxbxegedabagacad

# color grep
export GREP_OPTIONS='--color=auto'
GREP_COLOR='1;32'

# Make ANSI blue (color 4) readable on dark backgrounds
# Claude Code uses this color for keywords (e.g. const, await, null)
printf '\033]4;4;#88bbff\a'
