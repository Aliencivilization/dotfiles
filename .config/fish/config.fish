if status is-interactive
end

function fish_greeting
    set -l user (whoami)
    set -l host (cat /etc/hostname)
    set -l kernel (uname -sr)
    set -l fishver (fish --version | awk '{print $3}')
    set -l uptime (uptime -p | string replace "up " "")
    set -l cpu (lscpu | grep "Model name" | cut -d ':' -f2 | string trim)

    # palette
    set -l frame brblack
    set -l text white
    set -l accent brmagenta
    set -l soft magenta

    set_color $frame
    echo "╭─────────────────────────────────────────────╮"

    # user@host
    printf "│ "
    set_color $accent
    printf "󰀄 "
    set_color $text
    printf "%-41s" "$user@$host"
    set_color $frame
    echo " │"

    # kernel
    printf "│ "
    set_color $accent
    printf "󰣇 "
    set_color $text
    printf "%-41s" "$kernel"
    set_color $frame
    echo " │"

    # fish
    printf "│ "
    set_color $accent
    printf " "
    set_color $text
    printf "%-41s" "fish $fishver"
    set_color $frame
    echo " │"

    # uptime
    printf "│ "
    set_color $accent
    printf "󰔚 "
    set_color $text
    printf "%-41s" "$uptime"
    set_color $frame
    echo " │"

    # cpu
    printf "│ "
    set_color $accent
    printf " "
    set_color $text
    printf "%-41s" "$cpu"
    set_color $frame
    echo " │"

    echo "╰─────────────────────────────────────────────╯"

    echo

    # centered welcome
    set_color $frame
    printf "%15s" ""

    set_color $accent
    printf "✦ "

    set_color white
    printf "welcome back"

    set_color $accent
    printf " ✦\n"

    set_color normal
end

starship init fish | source
export PATH="$HOME/.local/bin:$PATH"
alias dots='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias dots='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
