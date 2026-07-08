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

info() { echo -e "${C_CYAN}::${C_RESET} $*"; }
ok() { echo -e "${C_GREEN}✓${C_RESET} $*"; }
warn() { echo -e "${C_YELLOW}!${C_RESET} $*"; }

echo -e ""
echo -e "${C_BOLD}${C_CYAN}QShellector Installer${C_RESET}"
echo -e ""

# ─── 1. Install binary ─────────────────────────────────────────────────────
info "Installing qshellector to $INSTALL_DIR/"
mkdir -p "$INSTALL_DIR"
cp "$SCRIPT_DIR/qshellector" "$INSTALL_DIR/qshellector"
chmod +x "$INSTALL_DIR/qshellector"
ok "Installed qshellector binary"

# ─── 2. Create config directory ────────────────────────────────────────────
info "Setting up config directory at $CONFIG_DIR/"
mkdir -p "$CONFIG_DIR"
mkdir -p "$KEYBINDS_DIR"

# Copy default keybind files (don't overwrite existing ones)
if [[ -d "$SCRIPT_DIR/keybinds" ]]; then
    for kb in "$SCRIPT_DIR"/keybinds/*.lua; do
        [[ ! -f "$kb" ]] && continue
        local_name="$(basename "$kb")"
        if [[ -f "$KEYBINDS_DIR/$local_name" ]]; then
            read -p ":: Keybind $local_name already exists. Overwrite? [y/N] " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                cp -f "$kb" "$KEYBINDS_DIR/$local_name"
                ok "Updated keybind: $local_name"
            else
                info "Skipped keybind: $local_name"
            fi
        else
            cp "$kb" "$KEYBINDS_DIR/$local_name"
            ok "Copied keybind: $local_name"
        fi
    done
fi

# ─── 3. Detect active shell ────────────────────────────────────────────────
if [[ ! -f "$CONFIG_DIR/active" ]]; then
    running=$(ps aux | grep '[q]uickshell -c' | sed 's/.*quickshell -c \([^ ]*\).*/\1/' | head -1 || true)
    if [[ -n "$running" ]]; then
        echo "$running" > "$CONFIG_DIR/active"
        ok "Detected running shell: $running"
    else
        echo "nandoroid" > "$CONFIG_DIR/active"
        warn "No running shell detected, defaulting to: nandoroid"
    fi
else
    info "Active shell already set: $(cat "$CONFIG_DIR/active")"
fi

# ─── 4. Set up hyprland keybind directory ───────────────────────────────────
info "Setting up Hyprland integration..."
mkdir -p "$HYPR_QS_DIR"

# Activate keybinds for current shell
"$INSTALL_DIR/qshellector" status > /dev/null 2>&1 || true
active=$(cat "$CONFIG_DIR/active" 2>/dev/null || echo "")
if [[ -n "$active" && -f "$KEYBINDS_DIR/${active}.lua" ]]; then
    rm -f "$HYPR_QS_DIR/active_keybinds.lua"
    ln -sf "$KEYBINDS_DIR/${active}.lua" "$HYPR_QS_DIR/active_keybinds.lua"
    ok "Activated keybinds for: $active"
else
    echo "-- QShellector: no keybinds configured" > "$HYPR_QS_DIR/active_keybinds.lua"
    warn "No keybind file for active shell"
fi

# ─── 5. Patch execs.lua ────────────────────────────────────────────────────
if [[ -f "$HYPR_EXECS" ]]; then
    if grep -q 'qs -c.*nandoroid' "$HYPR_EXECS" && ! grep -q 'qshellector/active' "$HYPR_EXECS"; then
        info "Patching $HYPR_EXECS for persistent shell selection..."
        cp "$HYPR_EXECS" "$HYPR_EXECS.bak"
        ok "Backup created: execs.lua.bak"

        sed -i 's%hl.exec_cmd("qs -c nandoroid")%hl.exec_cmd("qs -c $(cat ~/.config/qshellector/active 2>/dev/null || echo nandoroid)")%' "$HYPR_EXECS"
        ok "Patched execs.lua for dynamic shell selection"
    elif grep -q 'qshellector/active' "$HYPR_EXECS"; then
        info "execs.lua already patched"
    else
        warn "Could not find 'qs -c nandoroid' in execs.lua — manual patch needed"
        echo -e "  ${C_DIM}Add this line to your hyprland execs:${C_RESET}"
        echo -e '  ${C_DIM}hl.exec_cmd("qs -c $(cat ~/.config/qshellector/active 2>/dev/null || echo nandoroid)")${C_RESET}'
    fi
else
    warn "Hyprland execs.lua not found at $HYPR_EXECS"
fi

# ─── 6. Patch hyprland.lua for keybinds ─────────────────────────────────────
HYPR_MAIN="$HYPR_DIR/hyprland.lua"
if [[ -f "$HYPR_MAIN" ]]; then
    if ! grep -q 'qshellector/active_keybinds' "$HYPR_MAIN"; then
        info "Adding keybind loader to hyprland.lua..."
        # Add require before the last line or after custom/nandoroid
        if grep -q 'custom/nandoroid' "$HYPR_MAIN"; then
            sed -i '/require("custom\/nandoroid")/a\\nrequire("qshellector/active_keybinds")' "$HYPR_MAIN"
            ok "Added keybind require after custom/nandoroid"
        else
            echo '' >> "$HYPR_MAIN"
            echo 'require("qshellector/active_keybinds")' >> "$HYPR_MAIN"
            ok "Appended keybind require to hyprland.lua"
        fi
    else
        info "hyprland.lua already loads qshellector keybinds"
    fi
else
    warn "hyprland.lua not found — add this manually:"
    echo '  require("qshellector/active_keybinds")'
fi

# ─── Done ───────────────────────────────────────────────────────────────────
echo -e ""
echo -e "${C_GREEN}${C_BOLD}Installation complete!${C_RESET}"
echo -e ""
echo -e "  ${C_BOLD}Usage:${C_RESET}"
echo -e "    qshellector           ${C_DIM}# Launch TUI selector${C_RESET}"
echo -e "    qshellector list      ${C_DIM}# List available shells${C_RESET}"
echo -e "    qshellector status    ${C_DIM}# Show active shell${C_RESET}"
echo -e "    qshellector switch X  ${C_DIM}# Switch to shell X${C_RESET}"
echo -e ""
echo -e "  ${C_BOLD}Keybinds:${C_RESET}"
echo -e "    Edit per-shell keybinds in: ${C_DIM}$KEYBINDS_DIR/${C_RESET}"
echo -e ""
echo -e "  ${C_DIM}Reload hyprland config to apply keybind changes.${C_RESET}"
