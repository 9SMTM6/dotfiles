#!/bin/sh
# Link selected config files to the root user
# they better not be security relevant!
# but that way we dont have to execute on every chezmoi update
# or do complicated checks for differences, 
# and adjustments to user get immediately applied 
# without the need for a chezmoi apply between.
# 
# note, I've only tested this to work with helix.
# I've seen some software refuse symbolically linked config files.

set -e

# could not find a better way to get to the chezmoi directory
cd ~/.local/share/chezmoi

# in here we link all files.
# be extremely careful to always add the slash after the target for directories.
# cant get pkexec working properly on ssh ;-|.
# pkexec sh <<EOF
sudo sh <<EOF
    ln -sf "$PWD"/dot_config/helix /root/.config/
    ln -sf "$PWD"/dot_config/starship.toml /root/.config/
    ln -sf "$PWD"/dot_zshrc /root/.zshrc
EOF
