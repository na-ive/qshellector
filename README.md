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
git clone https://github.com/youruser/QShellector.git
cd QShellector
./install.sh
```

The installer will:
1. Copy `qshellector` to `~/.local/bin/`
2. Set up `~/.config/qshellector/` with default keybinds
3. Detect your currently running shell

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
qshellector list         # List available shells
qshellector status       # Show active shell and running state
qshellector switch NAME  # Switch to a shell by name
qshellector restart      # Restart the current shell
qshellector fix-tray     # Fix system tray (D-Bus cleanup + restart)
qshellector detect-fonts # Re-run TUI font detection
qshellector help         # Show help
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
