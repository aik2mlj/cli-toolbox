# Lejun's Command-Line Toolbox

A curated collection of modern command-line tools and shell configurations for productive terminal-based development. Works on any Linux or macOS machine — whether you're on a **remote server without root access** or setting up a **local development environment**.

The toolbox includes a set of tools I find essential for daily development (see [Binary Tools Included](#binary-tools-included) below), along with their configurations. For more local desktop setup recommendations, see my [dotfile repo](https://github.com/aik2mlj/chezmoi).

## Installation

The [install.sh](./install.sh) script handles everything. It backs up any existing configs before installing.

### Clone the Repository

```shell
git clone https://github.com/aik2mlj/remote-server-configs.git && cd remote-server-configs
```

### For Remote Rootless Server

This downloads all binaries to `~/.local/bin/` (no root needed) and installs configs:

```shell
./install.sh                # install binaries + essential configs (with backup)
./install.sh --overwrite    # same, without backing up existing config files
```

To just install the binaries or to upgrade them:

```shell
# these are equivalent
./install.sh --binary-only
./install.sh --upgrade
```

### For Local Machine or Server with Root Access

Use your package manager (`apt`, `dnf`, `pacman`, `brew`, etc.) for the binaries, and only apply the configs:

```shell
brew install <packages>                           # change it to your package manager
./install.sh --config-only                        # install essential configs only
./install.sh --config-only --overwrite            # install essential configs, overwrite existing
```

### Post Installation

- If you prefer a shell other than `fish`, add `~/.local/bin` to your [PATH](https://www.howtogeek.com/658904/how-to-add-a-directory-to-your-path-in-linux/). With `fish`, this is already configured.

- Some tools require a [Nerd Font](https://www.nerdfonts.com/) to display icons correctly — install one locally and set it in your terminal emulator's settings.

- You may want to set the default shell to `fish`.
  - If this is a local setup, change the login shell with `chsh -s $(which fish)`.
  - If this is a remote server without a system-wide `fish` installed, you may want to check [this setup guide](https://wiki.archlinux.org/title/Fish#Setting_fish_as_interactive_shell_only).
    - If you always launch `tmux`, you are already covered — the default shell in `tmux` has been set to `fish`.

## Binary Tools Included

Here is a brief overview. I recommend browsing the quick start guide of each tool following the link, but only when you need it. Most of them are self-explanatory and intuitive to get started.

- [fish](https://fishshell.com/) - A smart and user-friendly command line shell. Smarter tabs, autocompletion and syntax highlighting built-in.
  - Recommended reading: The fish shell [tutorial](https://fishshell.com/docs/current/tutorial.html) and [interactive guide](https://fishshell.com/docs/current/interactive.html).
- [btop](https://github.com/aristocratos/btop) - A cool monitoring tool for system resources. `htop` alternative.
- [difftastic](https://difftastic.wilfred.me.uk/): A structural diff tool that understands syntax.
  - It provides a more intuitive and readable diff output compared to `diff` or `git diff`, especially for code changes.
- [dust](https://github.com/bootandy/dust) - A more intuitive version of `du` in rust, handy to inspect disk usage.
- [eza](https://github.com/eza-community/eza) - A modern alternative to `ls` with colors and icons.
- [fd](https://github.com/sharkdp/fd) - A simple, fast and user-friendly alternative to `find`.
- [7z](https://www.7-zip.org/) - A file archiver with a high compression ratio.
- [fzf](https://github.com/junegunn/fzf) - A blazingly fast command-line fuzzy finder.
- [lazygit](https://github.com/jesseduffield/lazygit) - An intuitive terminal UI for `git`.
  - With usually just a few keystrokes to perform pull, fetch, push, or commit, I found it much easier to use than git commands and all the GUI git tools. It also includes advanced git cherry-picking, rebasing, and stash management features at hand.
- [mcat](https://github.com/Skardyy/mcat) - A versatile viewer that renders many file types (markdown, image/video, pdf, docx, pptx, xlsx, html, etc.) directly in terminal. Very useful for `yazi` preview.
- [mediainfo](https://mediaarea.net/en/MediaInfo) - Displays technical and tag information about media files. Useful for `yazi` preview.
- [neovim](https://neovim.io/) - A hyperextensible Vim-based text editor. My choice of text editor.
- [ripgrep](https://github.com/BurntSushi/ripgrep) - A modern (and much faster) alternative to `grep`. Recursively searches directories for a regex pattern.
- [starship](https://starship.rs/) - A minimal, blazing-fast, and infinitely customizable prompt for any shell.
- [uv](https://docs.astral.sh/uv/) - An extremely fast Python package and project manager, written in Rust.
  - I truly recommend this over `conda` or `venv` for managing Python environments in most cases. It's a single tool that replaces `pip`, `pip-tools`, `pipx`, `poetry`, `pyenv`, `twine`, `virtualenv`, and more. Plus it's 10-100x faster than `pip`.
- [yazi](https://yazi-rs.github.io/) - A blazing fast terminal file manager written in Rust.
  - A must have for terminal browsing. Stop `cd`ing around and using `ls` to browse files. It has built-in fuzzy search, code highlighting, decompression, and image previews. Please see the [quick start docs](https://yazi-rs.github.io/docs/quick-start/).
- [zoxide](https://github.com/ajeetdsouza/zoxide) - A smarter `cd` command that remembers your most used directories and allows you to jump to them quickly.

## Configuration Details

- `tmux` - I use `tmux` as my terminal multiplexer. This configuration uses [oh my tmux](https://github.com/gpakosz/.tmux). It includes a status bar with system information, battery status, and more. Some things to note:
  - Please see the [original repository](https://github.com/gpakosz/.tmux) for keybindings and smart usages.
    - It adds a more handy prefix `ctrl + a` (compared to the default `ctrl + b`).
    - It includes some useful keybindings, such as `<prefix> + h/j/k/l` to switch between panes, and `<prefix> Ctrl + h/j/k/l` to switch between windows.
  - My personal tweaks are under the _user customizations_ section in the [`~/.tmux.conf.local`](home/.tmux.conf.local) file.
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
  - To speed up the shell startup, `conda init` is lazy-loaded only after you run `conda` command for the first time.

- `yazi` - The configuration files are located at [`~/.config/yazi/`](home/.config/yazi/). I basically installed some plugins to enhance the functionality and the look.
  - `shift + j/k` to navigate 5 times faster in the file list. `opt/alt + j/k` to seek 5 units up/down in the preview (e.g., see the next page of the previewed text file, or see the next frame of the previewed video).
  - [smart-enter.yazi](https://github.com/yazi-rs/plugins/tree/main/smart-enter.yazi) to open files or enter directories in one key (since I like vim keybindings, `l`).
  - [piper.yazi](https://github.com/yazi-rs/plugins/tree/main/piper.yazi) to pipe any shell command as a previewer.
  - [full-border.yazi](https://github.com/yazi-rs/plugins/tree/main/full-border.yazi) to make it look fancier.
  - [git.yazi](https://github.com/yazi-rs/plugins/tree/main/git.yazi) to show the status of git file changes in the file list.
  - [compress.yazi](https://github.com/KKV9/compress.yazi) to compress selected files to an archive (shortcut: `ca`).
  - [mediainfo.yazi](https://github.com/boydaihungst/mediainfo.yazi) to show thumbnail using `ffmpeg` and media metadata using `mediainfo` (toggle showing metadata: `<f9>`).

- `lazygit` - The configuration file is located at [`~/.config/lazygit/config.yml`](home/.config/lazygit/config.yml). The default diff tool is set to `difftastic`, which provides a more intuitive diff output.

## Optional

- Neovim configuration: Only if you want to go hard-core using Neovim as your main editor in the terminal. I recommend [LazyVim](https://www.lazyvim.org/) as a base setup. It saves a tone of time providing a full-fledged IDE experience out of the box. But still be prepared to spend a fare amount of time to go through all the tools and configure your own version. Check [my configuration](https://github.com/aik2mlj/lazyvim-config) if you want to take some reference.

- [Zellij](https://zellij.dev/): Tired of remembering all the `tmux` shortcuts? `zellij` is a modern Rust alternative to `tmux` with a more intuitive UI, keybindings, and many great features.

- [Lazydocker](https://github.com/jesseduffield/lazydocker): Similar to `lazygit`, but for Docker. It provides a terminal UI for managing Docker containers, images, and volumes.

- [nvtop](https://github.com/Syllo/nvtop) or [nvitop](https://github.com/XuehaiPan/nvitop) for GPU monitoring: If you are working with GPUs, these tools provide a nice terminal UI to monitor GPU usage, memory, and processes.

- My choice of terminal emulator? [Kitty](https://sw.kovidgoyal.net/kitty/), [WezTerm](https://wezterm.org/), or [iTerm2](https://iterm2.com/).

- Wanna manage your configuration files gracefully? Check out [dotfiles](https://dotfiles.github.io/) for tutorials and tools. My choice is [chezmoi](https://www.chezmoi.io/).

## Technical Details

If you choose to use this script to install the binaries (instead of using your package manager if you are on a local machine), they are downloaded at install time from their official GitHub releases using [gah](https://github.com/get-gah/gah) (vendored and modified in [`tools/gah`](tools/gah)). It will automatically detect your system architecture and download the appropriate binaries. All tools, including `jq` (required by gah) if not already present, are installed to `~/.local/bin/` without root.
