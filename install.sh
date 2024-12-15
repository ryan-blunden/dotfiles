#! /usr/bin/env bash

set -e

echo "[info]: Configuring Git..."
cp -f .gitconfig ~/.gitconfig

echo "[info]: Customizing shell..."
curl -sS https://starship.rs/install.sh | sudo sh -s -- --force
cp -f starship.toml ~/.config
cp -f .bash_profile ~/
mkdir -p ~/.config

# Source .bash_profile from .bashrc so it's loaded in non-login shells
echo -e '\nif [ -f ~/.bash_profile ]; then\n    source ~/.bash_profile\nfi\n' >>~/.bashrc

# If this used in a Coder instance, presume VS Code Web is installed and
if [ "$(whoami)" == "coder" ]; then
    # Add code-server's bin directory to PATH so we can install extensions
    PATH="$PATH:/tmp/vscode-web/bin"

    echo "[info]: Waiting 30s for code-server to be ready..."
    sleep 30

    if [ -f /tmp/vscode-web/node ]; then
        echo "[info]: code-server ready. Installing VS Code extensions..."
        code-server \
            --install-extension dracula-theme.theme-dracula \
            --install-extension esbenp.prettier-vscode \
            --install-extension foxundermoon.shell-format \
            --install-extension ms-azuretools.vscode-docker \
            --install-extension GitHub.copilot \
            --install-extension redhat.vscode-yaml \
            --install-extension timonwong.shellcheck \
            --install-extension ms-python.flake8 \
            --install-extension ms-python.black-formatter
    fi
fi

echo "[info]: Dotfiles installation completed successfully."
