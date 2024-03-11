#!/bin/sh

chezmoi cd

sudo sh <<EOF
    cp -r ./dot_config/helix /root/.config
EOF
