#!/usr/bin/env bash

set -e

# Detect whether we are on Mac or Linux
if [[ -d "/Users" ]]; then
  PLATFORM=mac
  DOTFILES_DIR="$HOME/git/targos/dotfiles"
else
  PLATFORM=linux
  DOTFILES_DIR=$(dirname $(realpath "$0"))
fi

function ensure-symlink {
  SOURCE_INPUT="$1"
  DESTINATION_INPUT="$2"

  if [[ -z "$DESTINATION_INPUT" ]]; then
    DESTINATION_INPUT="$SOURCE_INPUT"
  fi

  SOURCE="$DOTFILES_DIR/$SOURCE_INPUT"
  if [[ ! -f "$SOURCE" ]]; then
    SOURCE="$DOTFILES_DIR/${PLATFORM}/${SOURCE_INPUT}"
  fi

  DESTINATION="$HOME/$DESTINATION_INPUT"
  if [[ ! -a "$DESTINATION" ]]; then
    echo "Creating symlink for $DESTINATION"
    ln -s "$SOURCE" "$DESTINATION"
  fi
}

function install-oh-my-zsh {
  if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    echo "Installing Oh My Zsh"
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  fi
}

function install-volta {
  if [[ ! -d "$HOME/.volta" ]]; then
    echo "Installing Volta"
    curl https://get.volta.sh | bash -s -- --skip-setup
  fi
}

ensure-symlink .zshrc
ensure-symlink .gitconfig
ensure-symlink .gitignore_global
ensure-symlink .vimrc

install-oh-my-zsh
install-volta

if [[ $PLATFORM = "mac" ]]; then
  echo "mac-specific"
fi

echo "Setup complete"
