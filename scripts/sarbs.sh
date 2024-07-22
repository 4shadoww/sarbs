#!/bin/env bash

# Copyright (C) 2024 Noa-Emil Nissinen

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.    See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.    If not, see <https://www.gnu.org/licenses/>.

set -e

WORK_DIR=$(realpath $(dirname "$0")/..)
# Substitude user command
SUDO=sudo
# AUR manager
AUR_MANAGER=paru-bin
# AUR url
AUR_MANAGER_GIT="https://aur.archlinux.org/$AUR_MANAGER.git"


install_base() {
    $SUDO pacman --noconfirm --needed -S $(cat $WORK_DIR/resources/arch-packages.txt | sed '/^#/d')
}

install_shell() {
    CHSH=yes RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    cd $HOME/.oh-my-zsh/custom/plugins

    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git
    git clone --depth=1 https://github.com/zsh-users/zsh-history-substring-search.git
    git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git

    cd "$WORK_DIR"
}

get_neovim_config() {
    cd $HOME/.config
    git clone --depth=1 https://gitlab.com/4shadoww/lazyvim-config.git nvim

    cd "$WORK_DIR"
}

install_aur_manager() {
    cd "$WORK_DIR/temp"
    git clone "$AUR_MANAGER_GIT"
    cd "$AUR_MANAGER"

    makepkg
    $SUDO pacman --noconfirm -U *.pkg.tar.zst

    cd "$WORK_DIR"
}

install_suckless() {
    # DWM
    cd "$WORK_DIR/temp"

    git clone --depth=1 https://gitlab.com/4shadoww/dwm.git
    cd dwm

    git apply "$WORK_DIR/resources/dwm_generic.patch"

    $SUDO make install

    # SLSTATUS
    cd "$WORK_DIR/temp"

    git clone --depth=1 https://gitlab.com/4shadoww/slstatus.git
    cd slstatus

    $SUDO make install

    # ST
    cd "$WORK_DIR/temp"

    git clone --depth=1 --branch=0-8-4 https://gitlab.com/4shadoww/st.git
    cd st

    git checkout 0-8-4

    $SUDO make install

    cd "$WORK_DIR"
}

echo "working dir is $WORK_DIR"

echo "installing base..."

install_base

echo "installing shell"

install_shell

echo "deploying dotfiles..."

cp -r "$WORK_DIR/dotfiles/." "$HOME/."

echo "getting neovim configuration"

get_neovim_config

echo "installing aur manager.."

rm -rf "$WORK_DIR/temp"
mkdir -p "$WORK_DIR/temp"

install_aur_manager

echo "installing suckless packages.."

install_suckless

echo "sarbs installation done"
