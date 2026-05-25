#!/bin/bash

#Check error
[[ "$(id -u)" -eq 0 ]] && error "Не запускай от root"

#paru
if ! command -v paru &>/dev/null; then
	info "Установка paru..."
	sudo pacman -Sy --needed --noconfirm git base-devel 
	git clone https://aur.archlinux.org/paru.git /tmp/paru
	cd /tmp/paru && makepkg -si --noconfirm && cd ~
	rm -rf /tmp/paru
fi

#Packages
paru -S --needed --noconfirm \
	fish \
	kitty \
	nvim \
	obsidian \
	ttyper \
	thunar \
	gthumb \
	zen-browser \
	localsend \
	qbittorrent \
	timeshift \
	starship \
	noctalia-shell \

#Dotfiles
DOTFILES="$HOME/.dotfiles"

git clone https://github.com/Aliencivilization/dotfiles.git "$DOTFILES"

dots() {
	git --git-dir="$DOTFILES" --work-tree="$HOME" "$@"
}
#Backup's conflict
dots checkout 2>&1 | grep "^\s" | awk '{print $1}' | while read -r file; do
    mkdir -p "$HOME/.config-backup/$(dirname "$file")"
    mv "$HOME/$file" "$HOME/.config-backup/$file" 2>/dev/null || true
done

dots checkout
dots config --local status.showUntrackedFiles no

#Shell
chsh -s "$(which fish)"

info "Готово, теперь reboot"
