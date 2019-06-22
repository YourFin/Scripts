#!/bin/bash
# Needs to be passed to a function in bashrc or zshrc
# in order to work

function printParents() {
    parent="$(dirname $1)"
    echo -E "$(basename $1)"
    [ "$parent" != "/" ] && [ "$parent" != "$HOME" ] \
        && printParents "$parent"

}
function add_dash_e() {
    for arg in $@ ; do
        echo -En "-e '${arg:Q}' "
    done
}
function get_candidate_rg() {
    printParents "$(pwd)" \
        | eval rg --no-config -I --smart-case \
               --sort none \
               --color never \
               "$(add_dash_e $@)" \
        | head -n 1
}
function get_candidate_fzf() {
    cwd="$(pwd)"
    printParents "$(pwd)" \
        | fzf -q "$@" -1 -0
}
pwd | sed "s:\(.*/$(get_candidate_fzf $@)/\).*:\1:"
