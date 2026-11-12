# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
alias ls='ls --color=auto'
PS1='[\[\e[1;36m\]\u\[\e[1;33m\]@\[\e[1;32m\]\h\[\e[0m\] \W]\$ '
alias at='alacritty-themes'
alias r='ranger'
alias bt='bluetoothctl' 
alias upd='yay; flatpak update'
alias u='udisksctl'
command -v neofetch >/dev/null && neofetch
[[ -f ~/my-environment.sh ]] && source ~/my-environment.sh
alias mirrors="sudo reflector --country US --protocol https --latest 50 --sort rate --number 20 --save /etc/pacman.d/mirrorlist && sudo pacman -Syy"
# Copy the contents of any file to the system clipboard
clip() {
    if [[ $# -ne 1 || ! -f "$1" ]]; then
        echo "Usage: clipfile <filename>"
        return 1
    fi

    xclip -selection clipboard < "$1"
}

export EDITOR=nvim
export VISUAL=nvim
export FCEDIT=nvim

export PATH="$HOME/.local/bin:$PATH"
[[ -f ~/.bashrc.machine ]] && source ~/.bashrc.machine
[[ -f ~/.bashrc.local ]] && source ~/.bashrc.local
