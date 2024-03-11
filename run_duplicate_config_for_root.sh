#!/bin/sh
# Copy selected config files to the root user

set -e

# could not find a better way to get to the chezmoi directory
cd ~/.local/share/chezmoi

# in here we copy all files
sudo sh <<EOF
    cp -r ./dot_config/helix /root/.config
EOF
