# Lejun's Command-Line Toolbox

A curated collection of modern command-line tools and shell configurations for productive terminal-based development. Works on Linux, macOS, or WSL on Windows — whether you're setting up a **local development environment** or a **remote server without root access**.

The toolbox includes a set of tools I find essential for daily development (see [CLI Tools Included](#cli-tools-included) below), along with their configurations. For local (Linux) desktop setup recommendations, see my [dotfile repo](https://github.com/aik2mlj/chezmoi).

## Installation

The [install.sh](./install.sh) script handles everything. It backs up any existing configs before installing.

### Clone the Repository

```shell
git clone https://github.com/aik2mlj/cli-toolbox.git && cd cli-toolbox
```

### System-wide Installation

If you are on a machine with sudo access, and your distro packages are reasonably up-to-date (Arch Linux, Fedora, macOS), use your package manager (`dnf`, `pacman`, `brew`, etc.) for the binaries, and only apply the configs:

```shell
# for macOS with Homebrew
brew install fish bat btop difftastic dust eza fd sevenzip fzf lazygit mcat fresh-editor ripgrep starship yazi zoxide ffmpeg-full jq poppler resvg imagemagick-full mediainfo font-symbols-only-nerd-font
brew link ffmpeg-full imagemagick-full -f --overwrite

# for Arch Linux
paru -S --needed fish bat btop difftastic dust eza fd 7zip fzf lazygit mcat-bin fresh-editor-bin ripgrep starship yazi zoxide ffmpeg jq poppler resvg imagemagick mediainfo

# apply the configs
./install.sh --config-only                        # install essential configs only
./install.sh --config-only --overwrite            # install essential configs, overwrite existing
```

Do remember to upgrade the binaries from time to time with your package manager.

### User-scoped (Rootless) Installation

Choose this if you don't have root access to the machine, e.g., a restricted server. Or you are on Linux distros with dated packages in the official repo, like Ubuntu or Debian (since this toolbox is only tested on the latest versions). This downloads all binaries to `~/.local/bin/` (no root needed) and installs configs:

```shell
./install.sh                # install binaries + essential configs (with backup)
./install.sh --overwrite    # same, without backing up existing config files
```

To just install the binaries or to upgrade (reinstall) them:

```shell
# these are equivalent
./install.sh --binary-only
./install.sh --upgrade
```

You may additionally install `ffmpeg` (from [this repo](https://github.com/BtbN/FFmpeg-Builds)’s nightly binary) using this script, if you don't have it already. `ffmpeg` is a powerful tool for audio and video processing. It can be included for video thumbnail preview in `yazi`.

```shell
./install.sh --ffmpeg
```

### Customized Installation

If you just want to install a few tools missing from your repo, or some additional tools that are not included here, you can use [gah](https://github.com/get-gah/gah) to manually install them:

```shell
./install.sh --gah                                # this installs gah, the binary installer, to ~/.local/bin/
gah install Skardyy/mcat                          # say, mcat is not in your repo
gah install jesseduffield/lazydocker              # install lazydocker, which is not included in the toolbox
```

Run `gah --help` to check the usage. Consult the [gah](https://github.com/get-gah/gah) documentation for more details.

And of course, you can manually copy individual config files in this repo to their respective location in your home directory.

### Terminal Emulator

Use a modern terminal emulator that renders images and [Nerd Font](https://www.nerdfonts.com/) well. I recommend [Ghostty](https://ghostty.org/) which just works out-of-the-box, or [Kitty](https://sw.kovidgoyal.net/kitty/) if you need more features and extensive configurability (what I use).

- You may find it very helpful knowing your emulator's tab / window management and various keybindings. For Ghostty, take a look at this [cheat sheet](https://ricoberger.de/cheat-sheets/ghostty/).

Now, simply open the emulator and enjoy your beautified and supercharged terminal!

### Post Installation

- You may want to set the default shell to `fish`.
  - If this is a local setup, change the login shell with `chsh -s $(which fish)`. If this fails, add `fish` to `/etc/shells` first with `sudo sh -c 'echo $(which fish) >> /etc/shells'`.
    - You may also just need to set `fish` as a command to run at launch in your terminal emulator's settings without changing the login shell. For Ghostty users, this is already covered in this config.
  - If this is a remote server without a system-wide `fish` installed, you may want to check [this setup guide](https://wiki.archlinux.org/title/Fish#Setting_fish_as_interactive_shell_only).
    - If you always launch `tmux`, you are already covered — the default shell in `tmux` has been set to `fish`.

- If you want to install additional binaries to `~/.local/bin/`, see [Customized Installation](#customized-installation)

- Check out [Optional](#optional) for additional tools and configs that may interests you.

## CLI Tools Included

Here is a brief overview. I recommend browsing the quick start guide of each tool following the link, but only when you need it. Most of them are self-explanatory and intuitive to get started.

- [fish](https://fishshell.com/) - A smart and user-friendly command line shell. Smarter tabs, autocompletion and syntax highlighting built-in.
  - Recommended reading: The fish shell [tutorial](https://fishshell.com/docs/current/tutorial.html) and [interactive guide](https://fishshell.com/docs/current/interactive.html).
- [bat](https://github.com/sharkdp/bat) - A `cat` clone with syntax highlighting and Git integration. Used by `fzf.fish` to preview files in directory search.
- [btop](https://github.com/aristocratos/btop) - A cool monitoring tool for system resources. `htop` alternative.
- [difftastic](https://difftastic.wilfred.me.uk/): A structural diff tool that understands syntax.
  - It provides a more intuitive and readable diff output compared to `diff` or `git diff`, especially for code changes.
- [dust](https://github.com/bootandy/dust) - A more intuitive version of `du` in rust, handy to inspect disk usage.
- [eza](https://github.com/eza-community/eza) - A modern alternative to `ls` with colors and icons.
- [fd](https://github.com/sharkdp/fd) - A simple, fast and user-friendly alternative to `find`.
- [7-zip](https://www.7-zip.org/) - A file archiver with a high compression ratio.
- [fzf](https://github.com/junegunn/fzf) - A blazingly fast command-line fuzzy finder.
- [lazygit](https://github.com/jesseduffield/lazygit) - An intuitive terminal UI for `git`.
  - With usually just a few keystrokes to perform pull, fetch, push, or commit, I found it much easier to use than git commands and all the GUI git tools. It also includes advanced git cherry-picking, rebasing, and stash management features at hand.
- [mcat](https://github.com/Skardyy/mcat) - A versatile viewer that renders many file types (markdown, image/video, pdf, docx, pptx, xlsx, html, etc.) directly in terminal. Very useful for `yazi` preview.
- [fresh](https://getfresh.dev/) - A modern terminal text editor and IDE with zero learning curve. A VSCode-like experience in the terminal.
- [ripgrep](https://github.com/BurntSushi/ripgrep) - A modern (and much faster) alternative to `grep`. Recursively searches directories for a regex pattern.
- [starship](https://starship.rs/) - A minimal, blazing-fast, and infinitely customizable prompt for any shell.
- [yazi](https://yazi-rs.github.io/) - A blazing fast terminal file manager written in Rust.
  - A must have for terminal browsing. Stop `cd`ing around and using `ls` to browse files. It has built-in fuzzy search, code highlighting, decompression, and image previews. Please see the [quick start docs](https://yazi-rs.github.io/docs/quick-start/) and this [cheat sheet](https://ricoberger.de/cheat-sheets/yazi/).
- [zoxide](https://github.com/ajeetdsouza/zoxide) - A smarter `cd` command that remembers your most used directories and allows you to jump to them quickly.

Some additional tools ([jq](https://jqlang.org/), [poppler](https://poppler.freedesktop.org/), [ffmpeg](https://www.ffmpeg.org/), [resvg](https://github.com/linebender/resvg), [ImageMagick](https://imagemagick.org/), [mediainfo](https://mediaarea.net/en/MediaInfo)) are needed as dependencies for complete `yazi` preview function. See [yazi doc](https://yazi-rs.github.io/docs/installation/) for the reasons they are needed.

- If you are using the rootless installation, `jq`, `resvg`, `imagemagick` (`magick`), and `mediainfo` are installed automatically. `ffmpeg` is available separately (see [User-scoped Installation](#user-scoped-rootless-installation)) due to its large binary size; `poppler` unfortunately cannot be easily installed as a static binary, you may install it rootlessly from `conda-forge`.

## Configuration Details

- `fish` - I use `fish` as my shell. The configuration includes some useful functions, abbreviations and aliases. Please see the main configuration file at [`~/.config/fish/config.fish`](home/.config/fish/config.fish) for details. Some things to note:
  - `z` is an alias for `zoxide`. Try simply `z <partial name of a directory you've been to>` to jump to that directory.
  - The default prompt is set to use `starship`, which provides a nice and informative prompt.
  - The default editor is set to `fresh`.
  - `ctrl + o` to open the file manager `yazi` and will change the current working directory when exiting (the [wrapper](https://yazi-rs.github.io/docs/quick-start#shell-wrapper) is configured in [`functions/yazi-cd.fish`](home/.config/fish/functions/yazi-cd.fish)).
  - Fuzzy-finder keybindings come from [fzf.fish](https://github.com/PatrickF1/fzf.fish).
    - `ctrl + r` to search through your command history.
    - `ctrl + f` to search through your files under the current directory.
  - `ls`, `ll`, etc. are mapped to `eza` that shows colors and icons.
  - To speed up the shell startup, `conda init` is lazy-loaded only after you run `conda` command for the first time.

- `yazi` - The configuration files are located at [`~/.config/yazi/`](home/.config/yazi/). I basically installed some plugins to enhance the functionality and the look.
  - `shift + j/k` to navigate 5 times faster in the file list. `opt/alt + j/k` to seek 5 units up/down in the preview (e.g., see the next page of the previewed text file, or see the next frame of the previewed video).
  - [smart-enter.yazi](https://github.com/yazi-rs/plugins/tree/main/smart-enter.yazi) to open files or enter directories in one key (`l` or right-arrow).
  - [piper.yazi](https://github.com/yazi-rs/plugins/tree/main/piper.yazi) to pipe any shell command as a previewer.
  - [full-border.yazi](https://github.com/yazi-rs/plugins/tree/main/full-border.yazi) to make it look fancier.
  - [git.yazi](https://github.com/yazi-rs/plugins/tree/main/git.yazi) to show the status of git file changes in the file list.
  - [compress.yazi](https://github.com/KKV9/compress.yazi) to compress selected files to an archive (shortcut: `ca`).
  - [mediainfo.yazi](https://github.com/boydaihungst/mediainfo.yazi) to show thumbnail using `ffmpeg` and media metadata using `mediainfo` (toggle showing metadata: `<f9>`).

- `lazygit` - The configuration file is located at [`~/.config/lazygit/config.yml`](home/.config/lazygit/config.yml). The default diff tool is set to `difftastic`, which provides a more intuitive diff output.

- `ghostty` - Default shell is set to `fish` in [`~/.config/ghostty/config.ghostty`](home/.config/ghostty/config.ghostty).

- `tmux` - I usually rely on my terminal emulator's tab / window management for multi-tasking on a local machine. But when working on remote servers, `tmux` is essential to keep sessions alive when you disconnect. This configuration uses [oh my tmux](https://github.com/gpakosz/.tmux). It includes a status bar with system information, battery status, and more. Some things to note:
  - Please see the [original repository](https://github.com/gpakosz/.tmux) for keybindings and smart usages.
    - It adds a more handy prefix `ctrl + a` (compared to the default `ctrl + b`).
    - It includes some useful keybindings, such as `<prefix> + h/j/k/l` to switch between panes, and `<prefix> Ctrl + h/j/k/l` to switch between windows.
  - My personal tweaks are under the _user customizations_ section in the [`~/.tmux.conf.local`](home/.tmux.conf.local) file.
    - The default shell in `tmux` is set to `fish`. You may change it to your preferred shell by modifying the `default-shell` line.
    - A fix that enable ssh agent forwarding to work after re-attaching to `tmux` is included. See [this blog](https://werat.dev/blog/happy-ssh-agent-forwarding/) for more details.

## Optional

- If you are Lejun or you want to use every config in this repo, append `--all` flag to `./install.sh`. Do take a look at all the configs in the repo before applying everything.

- You can find cool fonts that support command-line icons at [Nerd Fonts](https://www.nerdfonts.com/font-downloads). Pick one you like, download and install it, and set it as the font in your terminal emulator. This might be needed if you notice some icons are missing (displayed as empty squares).

- [Neovim](https://neovim.io/): If you want to go hard-core using Neovim as your main editor in the terminal, I recommend [LazyVim](https://www.lazyvim.org/) as a base setup. It saves a tone of time providing a full-fledged IDE experience out of the box. But still be prepared to spend a fare amount of time to go through all the tools and configure your own version. This repo contains a minimum Lazyvim config tweaked to my liking. You can copy the Neovim config in this repo by

  ```shell
  ./install.sh --nvim               # install neovim binary (for rootless)
  ./install.sh --nvim-config        # apply neovim config
  ```

  And you may want to change `EDITOR` to `nvim` in `~/.config/fish/config.fish` or wherever you set the editor.

- [uv](https://docs.astral.sh/uv/): An extremely fast Python package and project manager, written in Rust. Highly recommended over `conda` or `venv` for managing Python environments in most cases — a single tool that replaces `pip`, `pip-tools`, `pipx`, `poetry`, `pyenv`, `twine`, `virtualenv`, and more, and 10–100x faster than `pip`. Install with `gah install astral-sh/uv` or your package manager.

- [Zellij](https://zellij.dev/): Tired of remembering all the `tmux` shortcuts? `zellij` is a modern Rust alternative to `tmux` with a more intuitive UI, keybindings, and many great features.

- [Lazydocker](https://github.com/jesseduffield/lazydocker): Similar to `lazygit`, but for Docker. It provides a terminal UI for managing Docker containers, images, and volumes.

- [nvtop](https://github.com/Syllo/nvtop) or [nvitop](https://github.com/XuehaiPan/nvitop) for GPU monitoring: If you are working with GPUs, these tools provide a nice terminal UI to monitor GPU usage, memory, and processes.

- Wanna manage your configuration files gracefully? Check out [dotfiles](https://dotfiles.github.io/) for tutorials and tools. My choice is [chezmoi](https://www.chezmoi.io/).

- For local (Linux) desktop setup recommendations, see my [dotfile repo](https://github.com/aik2mlj/chezmoi).

## Technical Details

If you choose to use this script to install the binaries (instead of using your package manager if you are on a local machine), they are downloaded at install time from their official GitHub releases using [gah](https://github.com/get-gah/gah) (vendored and modified in [`tools/gah`](tools/gah)). It will automatically detect your system architecture and download the appropriate binaries. All tools, including `jq` (required by gah) if not already present, are installed to `~/.local/bin/` without root.
