if [ -n "$BASH" ]; then
    INIT_SHELL="bash"
elif [ -n "$ZSH_NAME" ]; then
    INIT_SHELL="zsh"
else
    INIT_SHELL="unknown"
fi
eval "$(starship init $INIT_SHELL)"
eval "$(atuin init $INIT_SHELL)"

# would love that, but it takes up too much space in applications like vscode etc
# eval "$(zellij setup --generate-auto-start zsh)"

eval $(thefuck --alias)

