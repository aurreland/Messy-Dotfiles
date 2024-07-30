#!/usr/bin/env nix-shell
#!nix-shell -i bash -p hyprland
hyprctl dispatch "$1" $(((($(hyprctl activeworkspace -j | jq -r .id) - 1) / 10) * 10 + $2))
