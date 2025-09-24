#!/bin/bash

# Abort if GDB_TMUX_FILE is not defined
if [ -z $GDB_TMUX_FILE ]; then
  echo "Environment variable GDB_TMUX_FILE not defined"
  return
fi

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <exec>"
    exit 1
fi

program=$1

# Create new pane and retrieve its ID
tmux split-window
# Did not find a better way to wait for file to be created
sleep 1

if [ -e "$GDB_TMUX_FILE" ]; then
  pane=$(cat $GDB_TMUX_FILE)
  echo "Using $pane for GDB output"
else
  echo "File $GDB_TMUX_FILE not found"
  exit 1
fi

tty_file="$GDB_TMUX_FILE.tty"
tmux send-keys -t "$pane" "tty > $tty_file" Enter
sleep 1

if [ -e "$tty_file" ]; then
  tty_value=$(cat $tty_file)
else
  echo "Could not find file $tty_file"
  exit 1
fi

# Let the other pane sleep so shell does not interfere with tty input
tmux send-keys -t "$pane" "sleep 10000" Enter

gdb -ex "tty $tty_value" $program
