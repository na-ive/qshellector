-- QShellector keybinds for: end4-pC (Illogical Impulse)
-- These keybinds are activated when end4-pC is the active shell.
-- Symlinked to ~/.config/hypr/qshellector/active_keybinds.lua on switch.

local end4 = "qs -c end4-pC ipc call"
local scripts = "~/.config/quickshell/end4-pC/scripts"

hl.unbind("CTRL + ALT + Delete")
hl.unbind("XF86MonBrightnessUp")
hl.unbind("XF86MonBrightnessDown")
hl.unbind("SUPER + Period")
hl.unbind("SUPER + V")
hl.unbind("SUPER + SHIFT + S")
hl.unbind("SUPER + SHIFT + R")
hl.unbind("SUPER + SHIFT + X")
hl.unbind("SUPER + Tab")

-- Shell UI toggles
hl.bind("SUPER + Super_L", hl.dsp.exec_cmd(end4 .. " search toggle"), { release = true })
hl.bind("SUPER + Tab", hl.dsp.exec_cmd(end4 .. " overlay toggle"))
hl.bind("SUPER + N", hl.dsp.exec_cmd(end4 .. " sidebarRight toggle"))
hl.bind("SUPER + A", hl.dsp.exec_cmd(end4 .. " sidebarLeft toggle"))
hl.bind("SUPER + I", hl.dsp.exec_cmd(end4 .. " settings toggle"))
hl.bind("SUPER + L", hl.dsp.exec_cmd(end4 .. " lock activate"))
hl.bind("CTRL + ALT + Delete", hl.dsp.exec_cmd(end4 .. " session toggle"))

-- Screenshots & recording
hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd(end4 .. " region screenshot"))
hl.bind("SUPER + SHIFT + R", hl.dsp.exec_cmd(end4 .. " region recordWithSound"), { locked = true })
hl.bind("SUPER + SHIFT + X", hl.dsp.exec_cmd(end4 .. " screenTranslator toggle"))

-- Clipboard
hl.bind("SUPER + V", hl.dsp.exec_cmd(end4 .. " cliphistService toggle"))

-- Wallpaper
hl.bind("CTRL + SUPER + T", hl.dsp.exec_cmd(end4 .. " wallpaperSelector toggle"))

-- Shell management (via qshellector)
hl.bind("CTRL + SUPER + R", hl.dsp.exec_cmd("qshellector restart"))
hl.bind("CTRL + SUPER + L", hl.dsp.exec_cmd("qshellector fix-tray"))

-- Brightness
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(end4 .. " brightness increment"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(end4 .. " brightness decrement"), { locked = true, repeating = true })

-- Media
hl.bind("SUPER + Period", hl.dsp.global("quickshell:spotlightEmoji"), { description = "Emoji >> clipboard" })
