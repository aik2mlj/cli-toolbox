# Lejun's configurations for remote Linux servers

Hi there, this repository contains configurations and scripts that I use to set up my development environment quickly and efficiently.

## Installation

Please take a look at the [install.sh](./install.sh) script to see what it does. By default, it will copy all the binary tools to `~/.local/bin/`, backup the configurations files if you already have them, and copy the configuration files for `tmux`, `fish`, `starship`, and `yazi`.

```shell
./install.sh  # the necessary configurations with backup.
./install.sh --overwrite  # necessary confiurations without backup existing configuration files.
./install.sh --all  # all configurations, for my personal use.
```

Notice that the configuration requires a patched font to display icons correctly. You can install one of the [nerd fonts](https://www.nerdfonts.com/) **locally** as you like and configure your terminal emulator to use it in the settings.

## Binary tools included

The binary tools in this repository are compiled for the x86_64 architecture and are intended for use on remote Linux servers. They are located under `/home/.local/bin/` (in case you are using a shell other than `fish`, you need to [add it to your path](https://www.howtogeek.com/658904/how-to-add-a-directory-to-your-path-in-linux/). For `fish` users this is already configured.) Notice that you need to have `git-lfs` installed to pull the binaries.

Here is a brief overview. I recommend browsing the quick start guide of each tool following the link, but only when you need it. Most of them are self-explanatory and intuitive to get started.

- [fish](https://fishshell.com/) - A smart and user-friendly command line shell. Smarter tabs, autocompletion and syntax highlighting built-in.
    - Recommended reading: The fish shell [tutorial](https://fishshell.com/docs/current/tutorial.html) and [interactive guide](https://fishshell.com/docs/current/interactive.html).
- [btop](https://github.com/aristocratos/btop) - A cool monitoring tool for system resources. `htop` alternative.
- [dust](https://github.com/bootandy/dust) - A more intuitive version of `du` in rust, handy to inspect disk usage.
- [eza](https://github.com/eza-community/eza) - A modern alternative to `ls` with colors and icons.
- [fd](https://github.com/sharkdp/fd) - A simple, fast and user-friendly alternative to `find`.
- [7z](https://www.7-zip.org/) - A file archiver with a high compression ratio.
- [fzf](https://github.com/junegunn/fzf) - A blazingly fast command-line fuzzy finder.
- [lazygit](https://github.com/jesseduffield/lazygit) - An intuitive terminal UI for `git`.
    - With usually just a few keystrokes to perform pull, fetch, push, or commit, I found it much easier to use than git commands and all the GUI git tools. It also includes advanced git cherry-picking, rebasing, and stash management features at hand.
- [neovim](https://neovim.io/) - A hyperextensible Vim-based text editor. My choice of text editor.
- [ripgrep](https://github.com/BurntSushi/ripgrep) - A modern (and much faster) alternative to `grep`. Recursively searches directories for a regex pattern.
- [starship](https://starship.rs/) - A minimal, blazing-fast, and infinitely customizable prompt for any shell.
- [uv](https://docs.astral.sh/uv/) - An extremely fast Python package and project manager, written in Rust.
    - I truly recommend this over `conda` or `venv` for managing Python environments in most cases. It's a single tool that replaces `pip`, `pip-tools`, `pipx`, `poetry`, `pyenv`, `twine`, `virtualenv`, and more. Plus it's 10-100x faster than `pip`.
- [yazi](https://yazi-rs.github.io/) - A blazing fast terminal file manager written in Rust.
    - A must have for terminal browsing. Stop `cd`ing around and using `ls` to browse files. It has built-in fuzzy search, code highlighting, decompression, and image previews. Please see the [quick start docs](https://yazi-rs.github.io/docs/quick-start/).
- [zoxide](https://github.com/ajeetdsouza/zoxide) - A smarter `cd` command that remembers your most used directories and allows you to jump to them quickly.

## Configuration details

- `tmux` - I use `tmux` as my terminal multiplexer. This configuration uses [oh my tmux](https://github.com/gpakosz/.tmux). It includes a status bar with system information, battery status, and more. Some things to note:
    - Please see the [original repository](https://github.com/gpakosz/.tmux) for keybindings and smart usages.
        - It adds a more handy prefix `ctrl + a` (compared to the default `ctrl + b`).
        - It includes some useful keybindings, such as `<prefix> + h/j/k/l` to switch between panes, and `<prefix> Ctrl + h/j/k/l` to switch between windows.
    - My personal tweaks are under the *user customizations* section in the [`~/.tmux.conf.local`](home/.tmux.conf.local) file.
        - The default shell in `tmux` is set to `fish`. You can change it to your preferred shell by modifying the `default-shell` line.
        - A fix that enable ssh agent forwarding to work after re-attaching to `tmux` is included. See [this blog](https://werat.dev/blog/happy-ssh-agent-forwarding/) for more details.

- `fish` - I use `fish` as my shell. The configuration includes some useful functions, abbreviations and aliases. Please see the main configuration file at [`~/.config/fish/config.fish`](home/.config/fish/config.fish) for details. Some things to note:
    - `z` is an alias for `zoxide`. Try simply `z <partial name of a directory you've been to>` to jump to that directory.
    - The default prompt is set to use `starship`, which provides a nice and informative prompt.
    - The default editor is set to `neovim`. `vim` will become `nvim`. You can comment out the line if you don't want this behavior.
    - `ctrl + r` to search through your command history with `fzf`.
    - `ctrl + f` to search through your files under the current directory with `fzf`.
    - `ctrl + o` to open the file manager `yazi` and will change the current working directory when exiting (the [wrapper](https://yazi-rs.github.io/docs/quick-start#shell-wrapper) is configured in [`functions/yazi-cd.fish`](home/.config/fish/functions/yazi-cd.fish)).
    - `ls`, `ll`, etc. are mapped to `eza` that shows colors and icons.
    - To make the shell loading faster, `conda init` is lazy-loaded only after you run `conda` command for the first time.

- `starship` - Just some customizations to the prompt. The configuration file is located at [`~/.config/starship.toml`](home/.config/starship.toml). You can delete it if you want the default prompt, or modify it according to your liking.

- `yazi` - The configuration files are located at [`~/.config/yazi/`](home/.config/yazi/). I basically installed some plugins to enhance the functionality and the look.
    - `shift + j/k` to navigate 5 times faster in the file list. `opt/alt + j/k` to seek 5 units up/down in the preview (e.g., see the next page of the previewed text file, or see the next frame of the previewed video).
    - [smart-enter.yazi](https://github.com/yazi-rs/plugins/tree/main/smart-enter.yazi) to open files or enter directories in one key (since I like vim keybindings, `l`).
    - [piper.yazi](https://github.com/yazi-rs/plugins/tree/main/piper.yazi) to pipe any shell command as a previewer.
    - [full-border.yazi](https://github.com/yazi-rs/plugins/tree/main/full-border.yazi) to make it look fancier.
    - [git.yazi](https://github.com/yazi-rs/plugins/tree/main/git.yazi) to show the status of git file changes in the file list.
    - [compress.yazi](https://github.com/KKV9/compress.yazi) to compress selected files to an archive (shortcut: `ca`).


## Optional

- Neovim configuration: Only if you want to go hard-core using Neovim as your main editor in the terminal. I recommend [LazyVim](https://www.lazyvim.org/) as a base setup. It saves a tone of time providing a full-fledged IDE experience out of the box. But still be prepared to spend a fare amount of time to go through all the tools and configure your own version. Check [my configuration](https://github.com/aik2mlj/lazyvim-config) if you want to take some reference.

- [Zellij](https://zellij.dev/): Tired of remembering all the `tmux` shortcuts? `zellij` is a modern Rust alternative to `tmux` with a more intuitive UI, keybindings, and many great features.

- [Lazydocker](https://github.com/jesseduffield/lazydocker): Similar to `lazygit`, but for Docker. It provides a terminal UI for managing Docker containers, images, and volumes.

- My choice of terminal emulator? [Kitty](https://sw.kovidgoyal.net/kitty/) or [iTerm2](https://iterm2.com/).

- Wanna manage your configuration files gracefully? Check out [dotfiles](https://dotfiles.github.io/) for tutorials and tools. My choice is [chezmoi](https://www.chezmoi.io/).
