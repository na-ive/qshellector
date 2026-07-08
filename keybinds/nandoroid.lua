-- QShellector keybinds for: nandoroid
-- These keybinds are activated when nandoroid is the active shell.
-- Symlinked to ~/.config/hypr/qshellector/active_keybinds.lua on switch.

local nandoroid = "qs -c nandoroid ipc call"
local scripts = "~/.config/quickshell/nandoroid/scripts"

hl.unbind("SUPER + Q")
hl.unbind("SUPER + T")
hl.unbind("SUPER + Return")
hl.unbind("SUPER + Return")
hl.unbind("SUPER + W")
hl.unbind("SUPER + E")
hl.unbind("CTRL + ALT + Delete")
hl.unbind("XF86MonBrightnessUp")
hl.unbind("XF86MonBrightnessDown")
hl.unbind("SUPER + Period")
hl.unbind("SUPER + V")
hl.unbind("SUPER + G")
hl.unbind("SUPER + SHIFT + S")
hl.unbind("SUPER + SHIFT + A")
hl.unbind("SUPER + SHIFT + R")
hl.unbind("SUPER + SHIFT + X")
hl.unbind("SUPER + Tab")
hl.unbind("SUPER + D")
hl.unbind("CTRL + SHIFT + Escape")

-- App launchers
hl.bind("SUPER + Q", hl.dsp.window.close())
hl.bind("SUPER + T", hl.dsp.exec_cmd(scripts .. "/launch_first_available.sh kitty foot alacritty"))
hl.bind("SUPER + Return", hl.dsp.exec_cmd(scripts .. "/launch_first_available.sh kitty foot alacritty"))
hl.bind("SUPER + Return", hl.dsp.exec_cmd(scripts .. "/launch_first_available.sh kitty foot alacritty"))
hl.bind("SUPER + W", hl.dsp.exec_cmd(scripts .. "/launch_first_available.sh zen-browser firefox chromium google-chrome-stable"))
hl.bind("SUPER + E", hl.dsp.exec_cmd(scripts .. "/launch_first_available.sh dolphin nautilus thunar thunar-mobile"))

-- Shell UI toggles
hl.bind("SUPER + Super_L", hl.dsp.exec_cmd(nandoroid .. " spotlight toggle"), { release = true })
hl.bind("SUPER + Space", hl.dsp.exec_cmd(nandoroid .. " launcher toggle"))
hl.bind("SUPER + V", hl.dsp.exec_cmd(nandoroid .. " clipboard toggle"))
hl.bind("CTRL + SUPER + T", hl.dsp.exec_cmd(nandoroid .. " quickwallpaper toggle"))
hl.bind("SUPER + A", hl.dsp.exec_cmd(nandoroid .. " notifications toggle"))
hl.bind("SUPER + N", hl.dsp.exec_cmd(nandoroid .. " quicksettings toggle"))
hl.bind("SUPER + D", hl.dsp.exec_cmd(nandoroid .. " dashboard toggle"))
hl.bind("SUPER + I", hl.dsp.exec_cmd(nandoroid .. " settings toggle"))
hl.bind("SUPER + G", hl.dsp.exec_cmd(nandoroid .. " quickactions toggle"))
hl.bind("SUPER + Tab", hl.dsp.exec_cmd(nandoroid .. " overview toggle"))
hl.bind("SUPER + L", hl.dsp.exec_cmd(nandoroid .. " lock activate"))
hl.bind("CTRL + ALT + Delete", hl.dsp.exec_cmd(nandoroid .. " session toggle"))
hl.bind("CTRL + SHIFT + Escape", hl.dsp.exec_cmd(nandoroid .. " systemmonitor toggle"))

-- Screenshots & recording
hl.bind("SUPER + SHIFT + S", hl.dsp.global("quickshell:regionScreenshot"))
hl.bind("SUPER + SHIFT + R", hl.dsp.global("quickshell:regionRecord"), { locked = true })
hl.bind("SUPER + SHIFT + X", hl.dsp.global("quickshell:regionOcr"))
hl.bind("SUPER + SHIFT + A", hl.dsp.global("quickshell:regionSearch"))

-- Emoji & clipboard
hl.bind("SUPER + Period", hl.dsp.global("quickshell:spotlightEmoji"), { description = "Emoji >> clipboard" })
hl.bind("SUPER + V", hl.dsp.global("quickshell:spotlightClipboard"), { description = "Clipboard history >> clipboard" })

-- Shell management (via qshellector)
hl.bind("CTRL + SUPER + R", hl.dsp.exec_cmd("qshellector restart"))
hl.bind("CTRL + SUPER + L", hl.dsp.exec_cmd("qshellector fix-tray"))

-- Power & brightness
hl.bind("XF86PowerOff", hl.dsp.exec_cmd(nandoroid .. " session toggle"))
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(nandoroid .. " brightness increment || brightnessctl s 5%+ && " .. nandoroid .. " osd showBrightness"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(nandoroid .. " brightness decrement || brightnessctl s 5%- && " .. nandoroid .. " osd showBrightness"), { locked = true, repeating = true })
