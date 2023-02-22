#!/bin/bash

echo "Linking repositories in /usr/share/themes"

for D in *; do
    if [ -d "${D}" ]; then
        if [ -d "${D}/gtk-3.0" ]; then
            echo "Linking ${D}"
            ln -s "$PWD/${D}" "/usr/share/themes"
        else
            cd "${D}"
            for SD in *; do
                if [ -d "${SD}" ] && [ -d "${SD}/gtk-3.0" ]; then
                    echo "Linking ${SD}"
                    ln -s "$PWD/${SD}" "/usr/share/themes"
                fi
            done
            cd ..
        fi
    fi
done
