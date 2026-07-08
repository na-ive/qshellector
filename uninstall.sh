#!/usr/bin/env bash
# QShellector Uninstaller
# Removes qshellector and restores original hyprland config.

set -euo pipefail

INSTALL_DIR="$HOME/.local/bin"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/qshellector"
HYPR_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/hypr"
HYPR_EXECS="$HYPR_DIR/hyprland/execs.lua"
HYPR_MAIN="$HYPR_DIR/hyprland.lua"
HYPR_QS_DIR="$HYPR_DIR/qshellector"

C_BOLD='\033[1m'
C_GREEN='\033[32m'
C_CYAN='\033[36m'
C_YELLOW='\033[33m'
C_DIM='\033[2m'
C_RESET='\033[0m'

info() { echo -e "${C_CYAN}::${C_RESET} $*"; }
ok() { echo -e "${C_GREEN}✓${C_RESET} $*"; }
warn() { echo -e "${C_YELLOW}!${C_RESET} $*"; }

echo -e ""
echo -e "${C_BOLD}${C_CYAN}QShellector Uninstaller${C_RESET}"
echo -e ""

# ─── 1. Remove binary ──────────────────────────────────────────────────────
if [[ -f "$INSTALL_DIR/qshellector" ]]; then
    rm "$INSTALL_DIR/qshellector"
    ok "Removed $INSTALL_DIR/qshellector"
else
    info "Binary not found at $INSTALL_DIR/qshellector"
fi

# ─── 2. Restore execs.lua ──────────────────────────────────────────────────
if [[ -f "$HYPR_EXECS.bak" ]]; then
    info "Restoring execs.lua from backup..."
    cp "$HYPR_EXECS.bak" "$HYPR_EXECS"
    rm "$HYPR_EXECS.bak"
    ok "Restored original execs.lua"
elif [[ -f "$HYPR_EXECS" ]] && grep -q 'qshellector/active' "$HYPR_EXECS"; then
    warn "No backup found but execs.lua contains qshellector patch"
    echo -e "  ${C_DIM}Please manually restore the original qs -c line${C_RESET}"
fi

# ─── 3. Remove keybind require from hyprland.lua ───────────────────────────
if [[ -f "$HYPR_MAIN" ]] && grep -q 'qshellector/active_keybinds' "$HYPR_MAIN"; then
    sed -i '/qshellector\/active_keybinds/d' "$HYPR_MAIN"
    ok "Removed keybind loader from hyprland.lua"
fi

# ─── 4. Remove hypr qshellector directory ──────────────────────────────────
if [[ -d "$HYPR_QS_DIR" ]]; then
    rm -rf "$HYPR_QS_DIR"
    ok "Removed $HYPR_QS_DIR/"
fi

# ─── 5. Config cleanup ─────────────────────────────────────────────────────
if [[ -d "$CONFIG_DIR" ]]; then
    echo -e ""
    read -rp "Remove QShellector config ($CONFIG_DIR)? [y/N] " answer
    if [[ "${answer,,}" == "y" ]]; then
        rm -rf "$CONFIG_DIR"
        ok "Removed config directory"
    else
        info "Config directory kept at $CONFIG_DIR"
    fi
fi

echo -e ""
echo -e "${C_GREEN}${C_BOLD}Uninstallation complete!${C_RESET}"
echo -e "${C_DIM}Reload hyprland config to apply changes.${C_RESET}"
