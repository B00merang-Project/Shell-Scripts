#!/bin/bash

if [ ! -d $HOME/.themes ]; then
    mkdir $HOME/.themes
fi

for D in *; do
    if [ -d "${D}" ]; then
        if [ -d "${D}/gtk-3.0" ]; then
            echo "Linking ${D}"
            ln -s "$PWD/${D}" "$HOME/.themes"
        else
            cd "${D}"
            for SD in *; do
                if [ -d "${SD}" ] && [ -d "${SD}/gtk-3.0" ]; then
                    echo "Linking ${SD}"
                    ln -s "$PWD/${SD}" "$HOME/.themes"
                fi
            done
            cd ..
        fi
    fi
done
