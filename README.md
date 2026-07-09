# QShellector

A lightweight CLI tool to switch between [QuickShell](https://quickshell.outfoxxed.me/) configurations with auto-detection, persistent selection, and per-shell keybind management.

## Features

- **Auto-detection** — Scans `~/.config/quickshell/` for valid shell configurations
- **Dual-mode TUI** — Maximal mode (box-drawing borders, Nerd Font icons, gradient colors) and minimal mode (clean ASCII art, no borders) with auto-detection during install
- **Large typography** — "QSHELL" figlet header in both modes (Unicode blocks or ASCII art)
- **Persistent** — Selected shell survives reboots via Hyprland integration
- **Per-shell keybinds** — Each shell gets its own Hyprland keybind file, auto-activated on switch
- **Shell management** — Switch, restart, and fix tray issues from one tool
- **Zero dependencies** — Pure Bash, no external tools needed

## Installation

```bash
git clone https://github.com/na-ive/qshellector.git
cd QShellector
./install.sh
```

The installer will:
1. Copy `qshellector` to `~/.local/bin/`
2. Set up `~/.config/qshellector/` with default keybinds
3. Detect your currently running shell

### Shell Completions

Completions for Bash, Zsh, and Fish are provided in the `completions/` directory.

**Bash:**
```bash
sudo cp completions/qshellector.bash /usr/share/bash-completion/completions/qshellector
# Or source it in your ~/.bashrc:
# source /path/to/QShellector/completions/qshellector.bash
```

**Zsh:**
```zsh
sudo cp completions/_qshellector /usr/share/zsh/site-functions/
# Then restart your shell or run `compinit`
```

**Fish:**
```fish
cp completions/qshellector.fish ~/.config/fish/completions/
```

### Uninstall

```bash
./uninstall.sh
```

## Usage

### TUI Selector

```bash
qshellector
```

The TUI automatically detects your terminal capabilities during installation and selects the best rendering mode:
- **Maximal mode** features box-drawing borders, Nerd Font icons, and gradient colors for modern terminals.
- **Minimal mode** uses clean ASCII art and no borders for maximum compatibility.

Both modes support keyboard navigation, quick switching, and scrolling for large lists of shells.

| Key | Action |
|-----|--------|
| `↑` `↓` / `j` `k` | Navigate |
| `Enter` | Select and switch |
| `1`-`9` | Quick select by number |
| `r` | Restart current shell |
| `f` | Fix system tray |
| `q` / `Escape` | Quit |

### CLI Commands

```bash
qshellector           # Launch TUI selector
qshellector list      # List available shells
qshellector status    # Show active shell
qshellector switch X  # Switch to shell X
qshellector log       # Tail the active shell's log
qshellector restart      # Restart the current shell
qshellector fix-tray     # Fix system tray (D-Bus cleanup + restart)
qshellector detect-fonts # Re-run TUI font detection
qshellector help         # Show help
```

### Pop-up Terminal Keybind (Hyprland)

You can configure Hyprland to launch QShellector in a centered floating terminal window. This gives you quick access to switch shells without keeping a terminal constantly open.

Add the following to your Hyprland configuration:

```lua
-- Window rule for the floating terminal
hl.window_rule({ match = { class = "^(qshellector_term)$" }, float = 1, center = 1, size = "600 550" })

-- Keybind to launch the terminal (replace 'kitty ...' with your preferred terminal command, e.g., foot, alacritty)
hl.bind("CTRL + SUPER + Q", hl.dsp.exec_cmd("kitty --class qshellector_term -e qshellector"), { description = "Open QShellector" })
```



## Per-Shell Keybinds

Each shell can have its own Hyprland keybind file at:

```
~/.config/qshellector/keybinds/<shell_name>.lua
```

When you switch shells, QShellector symlinks the matching keybind file to:

```
~/.config/hypr/qshellector/active_keybinds.lua
```

To use these dynamic keybinds, load this symlink in your Hyprland Lua configuration. For example, add this to your `hyprland.lua`:
```lua
require("qshellector/active_keybinds")
```

### Default keybinds included

- `nandoroid.lua` — IPC toggles for launcher, dashboard, settings, etc.
- `end4-pC.lua` — IPC toggles for overlay, sidebars, region tools, etc.
- `ii.lua` — Global signals for Illogical Impulse shell overview, widgets, tools, etc.

### Creating keybinds for a new shell

1. Add a new shell config to `~/.config/quickshell/<name>/`
2. Create `~/.config/qshellector/keybinds/<name>.lua`
3. Add your Hyprland keybinds using the shell's IPC interface
4. Switch to the shell — keybinds activate automatically

## How It Works

### Shell Detection

QShellector scans `~/.config/quickshell/` for directories containing a `shell.qml` file. Directories ending in `.old` are filtered out.

### Persistence

The active shell name is stored in `~/.config/qshellector/active`. To ensure the selected shell survives reboots, update your Hyprland configuration (e.g., your Lua config or `execs.lua`) to read this file on startup.

For example, using Hyprland's Lua configuration:
```lua
-- Read the active shell, fallback to your preferred default (e.g., 'default-shell') if not set
hl.exec_cmd("quickshell -c $(cat ~/.config/qshellector/active 2>/dev/null || echo default-shell)")
```

### Switching Process

1. Kill running `quickshell` process
2. Write new shell name to state file
3. Symlink matching keybind file
4. Start `quickshell -c <name>` (daemonized)

### Tray Fix

The `fix-tray` command performs additional D-Bus cleanup to resolve system tray issues:

1. Kill quickshell
2. Find and kill the zombie `org.kde.StatusNotifierWatcher` owner
3. Restart quickshell
4. Send D-Bus re-registration signal

## File Structure

```
~/.config/qshellector/
├── active                         # Current shell name
└── keybinds/
    ├── nandoroid.lua              # Keybinds for nandoroid
    ├── end4-pC.lua                # Keybinds for end4-pC
    └── ii.lua                     # Keybinds for ii

~/.config/hypr/qshellector/
└── active_keybinds.lua            # Symlink to active keybind file
```

## License

GPL-3.0
