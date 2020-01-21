#!/bin/zsh

up () {
    cd "$($HOME/.config/opt/yf-scripts/helpers/find-up.sh $@)"
}

autoload -Uz up
