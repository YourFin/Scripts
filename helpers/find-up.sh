#!/bin/bash
# Needs to be passed to a function in bashrc or zshrc
# in order to work

# Returns the parents of a directory up to $HOME or /, whichever comes first
# defined recursively
function printParents() {
    parent="$(dirname "$1")"
    echo -E "$(basename "$1")"
    [ "$1" != "/" ] && [ "$1" != "$HOME" ] \
        && printParents "$parent"

}
function add_dash_e() {
    for arg in "$@" ; do
        echo -En "-e '${arg:Q}' "
    done
}
function get_candidate_rg() {
    printParents "$(dirname "$(pwd)")"  \
        | eval rg --no-config -I --smart-case \
               --sort none \
               --color never \
               "$(add_dash_e $@)" \
        | head -n 1
}
function get_candidate_fzf() {
    if [ "$#" -ne 0 ] ; then
        printParents "$(dirname "$(pwd)")" \
            | fzf -q "$@" -1 -0
    else
        printParents "$(dirname "$(pwd)")"  \
            | fzf -1 -0
    fi
}
if type -t fzf 2>&1 1>/dev/null ; then
    pwd | sed "s:\(.*/$(get_candidate_fzf $@)/\).*:\1:"
fi
