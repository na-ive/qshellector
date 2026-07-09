#!/usr/bin/env bash
# QShellector Installer
# Installs qshellector to ~/.local/bin/ and sets up config directory.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_DIR="$HOME/.local/bin"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/qshellector"
KEYBINDS_DIR="$CONFIG_DIR/keybinds"
HYPR_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/hypr"
HYPR_EXECS="$HYPR_DIR/hyprland/execs.lua"
HYPR_QS_DIR="$HYPR_DIR/qshellector"

C_BOLD='\033[1m'
C_GREEN='\033[32m'
C_CYAN='\033[36m'
C_YELLOW='\033[33m'
C_DIM='\033[2m'
C_RESET='\033[0m'

printf '\033[2J\033[H'
echo -e ""
echo -e "  ${C_BOLD}${C_CYAN}QShellector Installer${C_RESET}"
echo -e ""

# ─── 1. Install binary ─────────────────────────────────────────────────────
mkdir -p "$INSTALL_DIR"
cp "$SCRIPT_DIR/qshellector" "$INSTALL_DIR/qshellector"
chmod +x "$INSTALL_DIR/qshellector"

# ─── 2. Create config directory & copy keybinds ────────────────────────────
mkdir -p "$CONFIG_DIR"
mkdir -p "$KEYBINDS_DIR"

if [[ -d "$SCRIPT_DIR/keybinds" ]]; then
    for kb in "$SCRIPT_DIR"/keybinds/*.lua; do
        [[ ! -f "$kb" ]] && continue
        local_name="$(basename "$kb")"
        if [[ -f "$KEYBINDS_DIR/$local_name" ]]; then
            echo -e "  ${C_YELLOW}?${C_RESET} ${C_BOLD}${local_name}${C_RESET} already exists."
            read -p "    Overwrite? [y/N] " -n 1 -r
            printf '\n\033[2A\033[J'
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                cp -f "$kb" "$KEYBINDS_DIR/$local_name"
            fi
        else
            cp "$kb" "$KEYBINDS_DIR/$local_name"
        fi
    done
fi

# ─── 3. Font detection for TUI mode ────────────────────────────────────────
TUI_MODE_FILE="$CONFIG_DIR/tui_mode"
if [[ ! -f "$TUI_MODE_FILE" ]]; then
    echo -e "  ${C_BOLD}Font Detection${C_RESET}"
    echo -e "  This checks if your terminal supports Nerd Font icons"
    echo -e "  and Unicode box-drawing characters."
    echo -e ""
    echo -e "  ${C_BOLD}Test line:${C_RESET}  󰆍 󱂬  ╭─╮ │ ╰─╯  ❯ ▲ ▼ ● ○"
    echo -e ""
    echo -e "  If the icons and borders above render ${C_GREEN}cleanly${C_RESET}, answer ${C_BOLD}y${C_RESET}."
    echo -e "  If you see ${C_YELLOW}boxes${C_RESET} or ${C_YELLOW}missing glyphs${C_RESET}, answer ${C_BOLD}n${C_RESET}."
    echo -e ""
    read -p "  Display correctly? [y/N] " -n 1 -r
    printf '\n\033[10A\033[J'

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "maximal" > "$TUI_MODE_FILE"
    else
        echo "minimal" > "$TUI_MODE_FILE"
    fi
fi

# ─── 4. Detect active shell ────────────────────────────────────────────────
if [[ ! -f "$CONFIG_DIR/active" ]]; then
    running=$(ps aux | grep -E '\b(quickshell|qs) -c' | grep -v grep | sed -E 's/.*(quickshell|qs) -c ([^ ]*).*/\2/' | head -1 || true)
    if [[ -n "$running" ]]; then
        echo "$running" > "$CONFIG_DIR/active"
    else
        echo "nandoroid" > "$CONFIG_DIR/active"
    fi
fi

# ─── 5. Set up hyprland keybind directory ───────────────────────────────────
mkdir -p "$HYPR_QS_DIR"

"$INSTALL_DIR/qshellector" status > /dev/null 2>&1 || true
active=$(cat "$CONFIG_DIR/active" 2>/dev/null || echo "")
if [[ -n "$active" && -f "$KEYBINDS_DIR/${active}.lua" ]]; then
    rm -f "$HYPR_QS_DIR/active_keybinds.lua"
    ln -sf "$KEYBINDS_DIR/${active}.lua" "$HYPR_QS_DIR/active_keybinds.lua"
else
    echo "-- QShellector: no keybinds configured" > "$HYPR_QS_DIR/active_keybinds.lua"
fi



# ─── Done ───────────────────────────────────────────────────────────────────
printf '\033[3A\033[J'
echo -e "  ${C_GREEN}${C_BOLD}✓ Installation complete!${C_RESET}"
echo -e ""
echo -e "  ${C_BOLD}Usage:${C_RESET}"
echo -e "    qshellector           ${C_DIM}# Launch TUI selector${C_RESET}"
echo -e "    qshellector list      ${C_DIM}# List available shells${C_RESET}"
echo -e "    qshellector status    ${C_DIM}# Show active shell${C_RESET}"
echo -e "    qshellector switch X  ${C_DIM}# Switch to shell X${C_RESET}"
echo -e ""
echo -e "  ${C_BOLD}Keybinds:${C_RESET}"
echo -e "    Edit per-shell keybinds in: ${C_DIM}$KEYBINDS_DIR/${C_RESET}"
echo -e "    Run ${C_DIM}qshellector detect-fonts${C_RESET} to change TUI mode."
echo -e ""
echo -e "  ${C_DIM}Reload hyprland config to apply keybind changes.${C_RESET}"
echo -e ""
