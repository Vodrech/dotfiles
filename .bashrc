# ANSI color codes
BOLD="\[\e[1m\]"
RESET="\[\e[0m\]"
CYAN="\[\e[36m\]"
GREEN="\[\e[32m\]"
BLUE="\[\e[34m\]"

# Terminal line
export PS1="${CYAN} ${RESET}${BLUE}\u${RESET}:\w: "

ufetch
