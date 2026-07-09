_qshellector_completions() {
    local cur prev cmds shells
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    cmds="list status switch detect-fonts restart fix-tray log help"

    if [[ ${COMP_CWORD} == 1 ]]; then
        COMPREPLY=( $(compgen -W "${cmds}" -- ${cur}) )
        return 0
    fi

    if [[ ${COMP_CWORD} == 2 && "${prev}" == "switch" ]]; then
        if [[ -d ~/.config/quickshell ]]; then
            # Get directories in quickshell config, ignore .old
            shells=$(find -L ~/.config/quickshell -mindepth 1 -maxdepth 1 -type d ! -name "*.old" -exec basename {} \; 2>/dev/null)
            COMPREPLY=( $(compgen -W "${shells}" -- ${cur}) )
        fi
        return 0
    fi
}
complete -F _qshellector_completions qshellector
