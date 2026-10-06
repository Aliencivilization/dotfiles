if status is-interactive
end

function fish_greeting
	fastfetch
end

starship init fish | source
export PATH="$HOME/.local/bin:$PATH"
alias dots='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias dots='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
thefuck --alias | source 

function odystart
	systemctl --user start --now odysseus.service
end

function odystop
	systemctl --user stop --now odysseus.service
end

function odystatus
	systemctl --user status odysseus.service
end

function update
	sudo pacman -Syyu && paru -Syyu && paru
end

if test "$TERM_PROGRAM" = vscode
    function fish_prompt
        printf '❯ '
    end
end
