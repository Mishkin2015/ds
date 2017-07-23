# completion file for bash
# for help see:
#  - http://tldp.org/LDP/abs/html/tabexpansion.html
#  - https://www.debian-administration.org/article/317/An_introduction_to_bash_completion_part_2
#  - https://www.gnu.org/software/bash/manual/html_node/Programmable-Completion-Builtins.html

_ds()
{
    COMPREPLY=()   # Array variable storing the possible completions.
    local cur=${COMP_WORDS[COMP_CWORD]}     ## $2
    local prev=${COMP_WORDS[COMP_CWORD-1]}  ## $3

    if [[ $COMP_CWORD -eq 1 ]]; then
        local commands="version start stop restart shell exec remove"
        commands+=" build config create help info init runcfg snapshot"
        commands+=" $(_ds_custom_commands)"
        COMPREPLY=( $(compgen -W "$commands" -- $cur) )
    else
        cmd=${COMP_WORDS[1]}
        case $cmd in
            init)
                compopt -o dirnames
                ;;
            runcfg)
                local cfgscripts="apache2 get-ssl-cert mount_tmp_on_ram mysql phpmyadmin set_prompt ssmtp"
                cfgscripts+=" $(_ds_custom_cfgscripts)"
                COMPREPLY=( $(compgen -W "$cfgscripts" -- $cur) )
                ;;
            *) :
                ;;
        esac
    fi
}

_ds_custom_commands() {
    local commands=""
    source ./settings.sh
    [[ -d $SRC/cmd/ ]] && commands=$(ls $SRC/cmd/)
    commands="${commands//.sh/}"
    echo $commands
}

_ds_custom_cfgscripts() {
    local cfgscripts=""
    source ./settings.sh
    [[ -d $SRC/config/ ]] && cfgscripts=$(ls $SRC/config/)
    cfgscripts="${cfgscripts//.sh/}"
    echo $cfgscripts
}

complete -F _ds ds docker.sh src/docker.sh
