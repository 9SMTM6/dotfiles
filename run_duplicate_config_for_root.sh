#!/bin/sh

set -e

cd ~/.local/share/chezmoi

sudo sh <<EOF
    cp -r ./dot_config/helix /root/.config
EOF
