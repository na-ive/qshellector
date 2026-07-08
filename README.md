# QShellector

A lightweight CLI tool to switch between [QuickShell](https://quickshell.outfoxxed.me/) configurations with auto-detection, persistent selection, and per-shell keybind management.

## Features

- **Auto-detection** — Scans `~/.config/quickshell/` for valid shell configurations
- **TUI selector** — Keyboard-navigable interface with arrow keys, vim keys, and number shortcuts
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
4. Patch `~/.config/hypr/hyprland/execs.lua` for persistent selection
5. Add keybind loader to `~/.config/hypr/hyprland.lua`

### Uninstall

```bash
./uninstall.sh
```

## Usage

### TUI Selector

```bash
qshellector
```

```
  QShellector
  QuickShell Config Selector

   ❯ 1  nandoroid  ●
     2  end4-pC

  ↑↓ navigate  enter select  r restart  f fix-tray  q quit
```

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

This file is loaded by `hyprland.lua` via `require("qshellector/active_keybinds")`.

### Default keybinds included

- `nandoroid.lua` — IPC toggles for launcher, dashboard, settings, etc.
- `end4-pC.lua` — IPC toggles for overlay, sidebars, region tools, etc.

### Creating keybinds for a new shell

1. Add a new shell config to `~/.config/quickshell/<name>/`
2. Create `~/.config/qshellector/keybinds/<name>.lua`
3. Add your Hyprland keybinds using the shell's IPC interface
4. Switch to the shell — keybinds activate automatically

## How It Works

### Shell Detection

QShellector scans `~/.config/quickshell/` for directories containing a `shell.qml` file. Directories ending in `.old` are filtered out.

### Persistence

The active shell name is stored in `~/.config/qshellector/active`. On boot, Hyprland reads this file to start the correct shell:

```lua
-- In ~/.config/hypr/hyprland/execs.lua
hl.exec_cmd("qs -c $(cat ~/.config/qshellector/active 2>/dev/null || echo nandoroid)")
```

### Switching Process

1. Kill running `quickshell` and `cava` processes
2. Write new shell name to state file
3. Symlink matching keybind file
4. Start `quickshell -c <name>` (daemonized)

### Tray Fix

The `fix-tray` command performs additional D-Bus cleanup to resolve system tray issues:

1. Kill quickshell and cava
2. Find and kill the zombie `org.kde.StatusNotifierWatcher` owner
3. Restart quickshell
4. Send D-Bus re-registration signal

## File Structure

```
~/.config/qshellector/
├── active                         # Current shell name
└── keybinds/
    ├── nandoroid.lua              # Keybinds for nandoroid
    └── end4-pC.lua                # Keybinds for end4-pC

~/.config/hypr/qshellector/
└── active_keybinds.lua            # Symlink to active keybind file
```

## License

GPL-3.0
