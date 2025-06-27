# add some paths
set -gx PATH "$HOME/.local/bin" $PATH
set -gx PATH "$HOME/.npm-global/bin" $PATH
set -gx PATH /opt/cuda/bin $PATH
set -gx GEM_HOME "$HOME/.local/share/gem/ruby/3.0.0/bin"
set -gx PATH $GEM_HOME $PATH

# set the default pager to neovim
set -gx MANPAGER "nvim +Man!"

# set the default editor to neovim
set -gx EDITOR nvim
set -gx VISUAL nvim

# ctrl-f to search for files using fzf.fish
# ctrl-r to search for command history using fzf.fish
fzf_configure_bindings --directory=\cf

# ctrl-o to open yazi and change the current working directory when exiting yazi (see https://yazi-rs.github.io/docs/quick-start#shell-wrapper)
bind \co "yazi-cd; commandline -f repaint"

# use eza instead of ls
alias ls="eza -b --group-directories-first --icons"
alias la="eza -b -l -a --group-directories-first --icons"
alias ll="eza -b -l --group-directories-first --icons"
alias l.="eza -b -a --group-directories-first --icons | egrep '^\.'" # show only dotfiles
# also lt for tree display. see functions/lt.fish
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias wget='wget -c '
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias hw='hwinfo --short' # Hardware Info
alias jctl="journalctl -p 3 -xb"
# safe rm with logging
alias rm="/bin/rm -v > ~/.rm.log"

# let's use fish abbreviation cuz it's more transparent in command history

# for sudo editing files
abbr svim sudo -E nvim
# systemctl commands
abbr sys sudo systemctl
# vim will becomes neovim, comment out the next line if you want to use vim instead of nvim
abbr vim nvim
# human readable df
abbr df df -h
# top will become btop, comment out the next line if you want to use top instead of btop
abbr top btop
# very useful util to monitor GPU resources continuously
abbr nvd watch -n 1 nvidia-smi
# lazygit abbr
abbr lg lazygit
# git abbr
abbr gs git status
abbr gl "git log --graph --full-history --all --color --pretty=tformat:\"%x1b[31m%h%x09%x1b[32m%d%x1b[0m%x20%s%x20%x1b[33m(%an)%x1b[0m\""
# command history with timestamps
abbr history history --show-time='%F %T '

if status is-interactive
    # initialize starship prompt
    if type -q starship
        source (starship init fish --print-full-init | psub)
    end
    # initialize zoxide
    if type -q zoxide
        zoxide init fish | source
    end
end

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
# eval ~/miniconda3/bin/conda "shell.fish" "hook" $argv | source
# <<< conda initialize <<<

# Instead of initializing conda in the config.fish, we use a function to initialize it. This makes the shell loading much faster.
# see functions/conda-init.fish for details
alias conda "conda-init; conda"

# see functions/ for more fish function utils
