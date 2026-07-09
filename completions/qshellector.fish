# qshellector fish completions

function __qshellector_needs_command
    set -l cmd (commandline -opc)
    if test (count $cmd) -eq 1
        return 0
    end
    return 1
end

function __qshellector_get_shells
    if test -d ~/.config/quickshell
        find -L ~/.config/quickshell -mindepth 1 -maxdepth 1 -type d ! -name "*.old" -exec basename {} \; 2>/dev/null
    end
end

complete -f -c qshellector -n "__qshellector_needs_command" -a list -d "List available shells"
complete -f -c qshellector -n "__qshellector_needs_command" -a status -d "Show active shell"
complete -f -c qshellector -n "__qshellector_needs_command" -a switch -d "Switch to a specific shell"
complete -f -c qshellector -n "__qshellector_needs_command" -a detect-fonts -d "Detect and configure font mode"
complete -f -c qshellector -n "__qshellector_needs_command" -a restart -d "Restart the active shell"
complete -f -c qshellector -n "__qshellector_needs_command" -a fix-tray -d "Fix system tray issues"
complete -f -c qshellector -n "__qshellector_needs_command" -a help -d "Show help"

complete -f -c qshellector -n "contains switch (commandline -opc)" -a "(__qshellector_get_shells)"
