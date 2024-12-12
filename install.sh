#! /usr/bin/env bash

set -e

if [ -f ~/.dotfiles_installed ]; then
    echo "[info]: Dotfiles already installed. Exiting..."
    exit 0
fi

echo "[info]: Configuring Git..."
cp -f .gitconfig ~/.gitconfig

echo "[info]: Customizing shell profile..."
cp -f .bash_profile ~/.bash_profile

# Source .bash_profile from .bashrc so it's loaded in non-login shells
echo -e '\nif [ -f ~/.bash_profile ]; then\n    source ~/.bash_profile\nfi\n' >>~/.bashrc

# If this used in a Coder instance, presume VS Code Web is installed and
# add code-server's bin directory to PATH so we can install extensions
if [ "$(whoami)" == "coder" ]; then
    PATH="$PATH:/tmp/vscode-web/bin"
    echo "[info]: Checking if code-server is ready"
    timeout=30
    while [ ! -f /tmp/vscode-web/node ]; do
        sleep 5
        ((timeout--))
        if [ $timeout -le 0 ]; then
            echo "[error]: code-server was not ready after 30 seconds. Could not install extensions."
        fi
    done

    # Give VS Coder Server time to setup
    sleep 30
    if [ -f /tmp/vscode-web/node ]; then
        echo "[info]: code-server ready. Installing VS Code extensions..."
        code-server \
            --install-extension dracula-theme.theme-dracula \
            --install-extension esbenp.prettier-vscode \
            --install-extension foxundermoon.shell-format \
            --install-extension streetsidesoftware.code-spell-checker \
            --install-extension ms-azuretools.vscode-docker \
            --install-extension GitHub.copilot \
            --install-extension redhat.vscode-yaml \
            --install-extension timonwong.shellcheck \
            --install-extension ms-python.flake8 \
            --install-extension ms-python.black-formatter
    fi
fi

echo "[info]: Installing Django bash completion..."
mkdir -p ~/.local/bin
cp -f django_bash_completion "$HOME/.local/bin/"

echo "[info]: Dotfiles installation completed successfully."
touch ~/.dotfiles_installed
