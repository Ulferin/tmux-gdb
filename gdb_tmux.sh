#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <exec>"
    exit 1
fi

program=$1

# Create new pane and retrieve its ID and tty
pane="$(tmux split-pane -vPF "#D" "tail -f /dev/null")"
tty="$(tmux display-message -p -t "$id" '#{pane_tty}')"

tmux last-pane
gdb -ex "tty $tty" $program
tmux send-keys -t "$pane" C-c
