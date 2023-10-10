# Code that should work in the sh-compatible shells
eval $(thefuck --alias)
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT="-c"
