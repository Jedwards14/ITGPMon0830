#!/bin/sh
echo -ne '\033c\033]0;Introduction to Game Production Project\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Introduction to Game Production Project.x86_64" "$@"
