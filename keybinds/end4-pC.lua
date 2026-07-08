-- QShellector keybinds for: end4-pC (Illogical Impulse)
-- These keybinds are activated when end4-pC is the active shell.
-- We rely on the native bindings in ~/.config/hypr/hyprland/keybinds.lua for end4-pC.
-- Only qshellector specific keybinds are added here.

-- Shell management (via qshellector)
hl.bind("CTRL + SUPER + R", hl.dsp.exec_cmd("qshellector restart"))
hl.bind("CTRL + SUPER + L", hl.dsp.exec_cmd("qshellector fix-tray"))
