#!/bin/bash

for D in *; do
    if [ -d "${D}" ]; then
        ln -s "$PWD/${D}" "$HOME/.themes"  # your processing here
    fi
done
