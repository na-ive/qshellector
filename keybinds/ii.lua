-- QShellector keybinds for: ii (Illogical Impulse)
-- These keybinds are activated when ii is the active shell.
-- Symlinked to ~/.config/hypr/qshellector/active_keybinds.lua on switch.

local ii = "qs -c ii ipc call"
local scripts = "~/.config/quickshell/ii/scripts"

-- Unbind keys that will be overridden
hl.unbind("CTRL + ALT + Delete")
hl.unbind("XF86MonBrightnessUp")
hl.unbind("XF86MonBrightnessDown")
hl.unbind("SUPER + Period")
hl.unbind("SUPER + V")
hl.unbind("SUPER + SHIFT + S")
hl.unbind("SUPER + SHIFT + R")
hl.unbind("SUPER + SHIFT + X")
hl.unbind("SUPER + Tab")
hl.unbind("SUPER + Super_L")
hl.unbind("SUPER + I")
hl.unbind("CTRL + SUPER + T")
hl.unbind("SUPER + N")
hl.unbind("SUPER + A")
hl.unbind("SUPER + L")
hl.unbind("CTRL + SUPER + R")
hl.unbind("CTRL + SUPER + L")

-- Additional unbinds for newly added ii/end4-pC keys
hl.unbind("SUPER + Slash")
hl.unbind("SUPER + K")
hl.unbind("SUPER + M")
hl.unbind("SUPER + G")
hl.unbind("SUPER + J")
hl.unbind("CTRL + SUPER + ALT + T")
hl.unbind("CTRL + SUPER + SHIFT + D")
hl.unbind("CTRL + SUPER + P")
hl.unbind("SUPER + SHIFT + A")
hl.unbind("SUPER + SHIFT + T")
hl.unbind("SUPER + ALT + R")

-- Shell UI toggles
hl.bind("SUPER + Super_L", hl.dsp.global("quickshell:searchToggleRelease"), { release = true, description = "Shell: Toggle search" })
hl.bind("SUPER + Tab", hl.dsp.global("quickshell:overviewWorkspacesToggle"), { description = "Shell: Toggle overview" })
hl.bind("SUPER + N", hl.dsp.global("quickshell:sidebarRightToggle"), { description = "Shell: Toggle right sidebar" })
hl.bind("SUPER + A", hl.dsp.global("quickshell:sidebarLeftToggle"), { description = "Shell: Toggle left sidebar" })
hl.bind("SUPER + I", hl.dsp.exec_cmd(ii .. " settings toggle"), { description = "Shell: Toggle settings" })
hl.bind("SUPER + Slash", hl.dsp.global("quickshell:cheatsheetToggle"), { description = "Shell: Toggle cheatsheet" })
hl.bind("SUPER + K", hl.dsp.global("quickshell:oskToggle"), { description = "Shell: Toggle on-screen keyboard" })
hl.bind("SUPER + M", hl.dsp.global("quickshell:mediaControlsToggle"), { description = "Shell: Toggle media controls" })
hl.bind("SUPER + G", hl.dsp.global("quickshell:overlayToggle"), { description = "Shell: Toggle widget overlay" })
hl.bind("SUPER + J", hl.dsp.global("quickshell:barToggle"), { description = "Shell: Toggle bar" })
hl.bind("CTRL + ALT + Delete", hl.dsp.global("quickshell:sessionToggle"), { description = "Shell: Toggle session menu" })
hl.bind("SUPER + L", hl.dsp.exec_cmd("loginctl lock-session"), { description = "Session: Lock" })

-- Screenshots & recording & Utilities
hl.bind("SUPER + SHIFT + S", hl.dsp.global("quickshell:regionScreenshot"), { description = "Utilities: Screen snip" })
hl.bind("SUPER + SHIFT + A", hl.dsp.global("quickshell:regionSearch"), { description = "Utilities: Google Lens" })
hl.bind("SUPER + SHIFT + X", hl.dsp.global("quickshell:regionOcr"), { description = "Utilities: Character recognition >> clipboard" })
hl.bind("SUPER + SHIFT + T", hl.dsp.global("quickshell:screenTranslate"), { description = "Utilities: Translate screen content" })
hl.bind("SUPER + SHIFT + R", hl.dsp.global("quickshell:regionRecord"), { locked = true, description = "Utilities: Record region (no sound)" })
hl.bind("SUPER + ALT + R", hl.dsp.global("quickshell:regionRecord"), { locked = true })

-- Clipboard & Emoji
hl.bind("SUPER + V", hl.dsp.global("quickshell:overviewClipboardToggle"), { description = "Shell: Toggle clipboard" })
hl.bind("SUPER + Period", hl.dsp.global("quickshell:overviewEmojiToggle"), { description = "Shell: Toggle emoji" })

-- Wallpaper & Theming
hl.bind("CTRL + SUPER + T", hl.dsp.global("quickshell:wallpaperSelectorToggle"), { description = "Shell: Change wallpaper" })
hl.bind("CTRL + SUPER + ALT + T", hl.dsp.global("quickshell:wallpaperSelectorRandom"), { description = "Shell: Random wallpaper" })
hl.bind("CTRL + SUPER + SHIFT + D", hl.dsp.global("quickshell:toggleLightDark"), { description = "Shell: Toggle light/dark mode" })
hl.bind("CTRL + SUPER + P", hl.dsp.global("quickshell:panelFamilyCycle"), { description = "Shell: Cycle panel family" })

-- Shell management (via qshellector)
hl.bind("CTRL + SUPER + R", hl.dsp.exec_cmd("qshellector restart"), { description = "Shell: Restart widgets" })
hl.bind("CTRL + SUPER + L", hl.dsp.exec_cmd("qshellector fix-tray"))

-- Brightness
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(ii .. " brightness increment"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(ii .. " brightness decrement"), { locked = true, repeating = true })
