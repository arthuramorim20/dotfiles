#!/usr/bin/env bash
# Minimal bootstrap: install Ansible, then run the playbook.
# Run this once on a fresh machine; afterwards re-run ansible-playbook directly.
#
# Usage:
#   ./bootstrap.sh             # install ansible + run playbook
#   ./bootstrap.sh --check     # install ansible + dry-run

set -euo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly PLAYBOOK="$SCRIPT_DIR/ansible/playbook.yml"

EXTRA_ARGS=()
[ "${1:-}" = "--check" ] && EXTRA_ARGS=(--check --diff)

install_ansible_arch() {
  command -v ansible-playbook >/dev/null 2>&1 && return
  echo "==> installing ansible via pacman"
  sudo pacman -S --needed --noconfirm ansible
  # community.general for pacman/flatpak/homebrew modules
  ansible-galaxy collection install community.general
}

install_ansible_mac() {
  command -v ansible-playbook >/dev/null 2>&1 && return
  if ! xcode-select -p >/dev/null 2>&1; then
    echo "==> installing Xcode Command Line Tools (this opens a GUI prompt)"
    xcode-select --install
    echo "Re-run this script after the Command Line Tools finish installing."
    exit 1
  fi
  if ! command -v brew >/dev/null 2>&1; then
    echo "==> installing Homebrew"
    NONINTERACTIVE=1 /bin/bash -c \
      "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # add brew to PATH for this session (Apple Silicon default)
    [ -x /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
  echo "==> installing ansible via brew"
  brew install ansible
  ansible-galaxy collection install community.general
}

case "$(uname -s)" in
  Linux)
    [ -f /etc/arch-release ] || { echo "Linux detected but not Arch — aborting"; exit 1; }
    install_ansible_arch
    ;;
  Darwin)
    install_ansible_mac
    ;;
  *)
    echo "unsupported OS: $(uname -s)"; exit 1 ;;
esac

echo "==> running playbook${EXTRA_ARGS[*]:+ ${EXTRA_ARGS[*]}}"
exec ansible-playbook "$PLAYBOOK" --ask-become-pass "${EXTRA_ARGS[@]}"
