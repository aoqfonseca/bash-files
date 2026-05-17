# dotfiles

Personal development environment configuration for macOS and Linux.

## What's included

| Path | Purpose |
|------|---------|
| `zsh/zshrc_custom` | Zsh config — Oh My Zsh + Starship prompt, aliases, `trabalhar` loader |
| `tmux/tmux.conf` | Tmux — Catppuccin Mocha theme, vim-style navigation, TPM plugins |
| `nvim/init.lua` | Neovim — Kickstart-based config with lazy.nvim, LSP, Telescope, blink.cmp |
| `wezterm/wezterm.lua` | WezTerm terminal config with font selector and tmux-session plugins |
| `allacritty/alacritty.toml` | Alacritty config (mirrors WezTerm — Catppuccin Mocha, JetBrainsMono) |
| `.gitconfig` | Global git config with color output and shorthand aliases |
| `local/bin/tmuxsession` | `trabalhar` — fzf-powered tmux session switcher |
| `install_fonts.sh` | Cross-platform Nerd Fonts installer (dispatches to OS-specific script) |
| `install_nerd_fonts_linux.sh` | Linux font installer — downloads zips from GitHub releases |
| `install_nerd_fonts_macos.sh` | macOS font installer — uses Homebrew casks |
| `install_setup.sh` | Full dev environment bootstrap (Linux/apt) |

## Quick setup

### 1. Install Nerd Fonts

```bash
bash install_fonts.sh
```

Installs: FiraCode, Hack, Meslo, JetBrainsMono, Inconsolata, Iosevka, VictorMono.  
After installing, select a Nerd Font in your terminal preferences.

### 2. Bootstrap a new Linux machine

```bash
bash install_setup.sh
```

Installs: `build-essential`, `curl`, `git`, `fzf`, ASDF (Go + Node), GitHub CLI, Google Cloud SDK, Neovim (AppImage).

### 3. Symlink configs

Link each config to its expected location:

```bash
# Zsh
ln -sf "$PWD/zsh/zshrc_custom" ~/.zshrc

# Tmux
ln -sf "$PWD/tmux/tmux.conf" ~/.tmux.conf

# Neovim
mkdir -p ~/.config/nvim
ln -sf "$PWD/nvim/init.lua" ~/.config/nvim/init.lua

# WezTerm
mkdir -p ~/.config/wezterm
ln -sf "$PWD/wezterm/wezterm.lua" ~/.config/wezterm/wezterm.lua

# Alacritty
mkdir -p ~/.config/alacritty
ln -sf "$PWD/allacritty/alacritty.toml" ~/.config/alacritty/alacritty.toml

# Git
ln -sf "$PWD/.gitconfig" ~/.gitconfig

# tmuxsession utility
mkdir -p ~/.local/bin
ln -sf "$PWD/local/bin/tmuxsession" ~/.local/bin/tmuxsession
```

## Shell

Uses **Zsh** with [Oh My Zsh](https://ohmyzsh.com) and [Starship](https://starship.rs) prompt.

Active Oh My Zsh plugins: `git`, `ruby`, `python`.

Key aliases:

```zsh
alias zshconfig="nvim ~/.zshrc"
alias ohmyzsh="nvim ~/.oh-my-zsh"
```

### `trabalhar` — tmux project switcher

Sources from `~/.local/bin/tmuxsession`. Requires `$MY_WORKDIR` to be set.

```bash
trabalhar          # fzf picker over $MY_WORKDIR subdirectories
trabalhar myapp    # jump directly to $MY_WORKDIR/myapp
```

Creates a tmux session named after the directory (strips `_*-.` chars), then attaches or switches to it.

## Tmux

Theme: [Catppuccin Mocha](https://github.com/catppuccin/tmux).

Key bindings (prefix is default `Ctrl-b`):

| Key | Action |
|-----|--------|
| `prefix \|` | Split horizontally |
| `prefix -` | Split vertically |
| `prefix h/j/k/l` | Navigate panes |
| `prefix r` | Reload tmux config |
| `prefix c` | Reload `.zshrc` |

Plugins managed by [TPM](https://github.com/tmux-plugins/tpm):

- `catppuccin/tmux` — status bar theme
- `tmux-plugins/tmux-resurrect` + `tmux-continuum` — session persistence
- `omerxx/tmux-floax` — floating pane
- `fcsonline/tmux-thumbs` — hint-based copy
- `swaroopch/tmux-pomodoro` — pomodoro timer

**TPM setup:**

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# Inside tmux: press prefix + I to install plugins
```

## Neovim

Kickstart-based config using [lazy.nvim](https://github.com/folke/lazy.nvim). Leader key: `<Space>`.

**LSP servers** (auto-installed via Mason): `gopls`, `rust_analyzer`, `lua_ls`, `ty` (Python), `stylua`.

**Formatters** (via conform.nvim): `stylua` (Lua), `isort` + `ruff_format` (Python), `goimports` + `gofmt` (Go).

Notable plugins:

| Plugin | Purpose |
|--------|---------|
| `telescope.nvim` | Fuzzy finder — files, grep, LSP symbols |
| `blink.cmp` | Autocompletion with LuaSnip snippets |
| `nvim-treesitter` | Syntax highlighting for bash, Go, Rust, Python, Lua, JS, etc. |
| `neo-tree.nvim` | File explorer sidebar |
| `gitsigns.nvim` | Git gutter indicators |
| `which-key.nvim` | Keymap discovery popup |
| `todo-comments.nvim` | Highlights TODO/FIXME/NOTE in comments |
| `mini.nvim` | Text objects, surround, statusline |
| `tokyonight.nvim` | Color scheme (storm variant) |

Key Telescope mappings:

| Key | Action |
|-----|--------|
| `<leader>sf` | Find files |
| `<leader>sg` | Live grep |
| `<leader>sd` | Search diagnostics |
| `<leader>/` | Fuzzy search current buffer |
| `<leader><leader>` | Open buffers |

## Git aliases

Defined in `.gitconfig`:

```
ci  → commit
st  → status
br  → branch
co  → checkout
df  → diff
lg  → log -p
who → shortlog -s --
```

## Dependencies

| Tool | Install |
|------|---------|
| Zsh | `sudo apt install zsh` / `brew install zsh` |
| Oh My Zsh | [ohmyzsh.com](https://ohmyzsh.com) |
| Starship | [starship.rs](https://starship.rs) |
| Tmux | `sudo apt install tmux` / `brew install tmux` |
| TPM | `git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm` |
| Neovim | Via `install_setup.sh` or [neovim.io](https://neovim.io) |
| WezTerm | [wezfurlong.org/wezterm](https://wezfurlong.org/wezterm) |
| ASDF | Installed by `install_setup.sh` |
