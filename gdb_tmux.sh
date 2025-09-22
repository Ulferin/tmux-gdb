# Abort if GDB_TMUX_FILE is not defined
if [ -Z $GDB_TMUX_FILE ]; then
  echo "Environment variable GDB_TMUX_FILE not defined"
  return
fi

# Create new pane and retrieve its ID
tmux split-window
# Did not find a better way to wait for file to be created
sleep 1

filename="/home/federico/last_pane"
if [ -e "$filename" ]; then
  pane=$(cat $filename)
  echo "Using $pane for GDB output"
else
  echo "File $filename not found"
  return
fi

tmux send-keys -t "$pane" "tty > \$GDB_TMUX_FILE" Enter

if [ -e "$GDB_TMUX_FILE" ]; then
  tty_value=$(cat $GDB_TMUX_FILE)
else
  echo "Could not find file $GDB_TMUX_FILE"
  return
fi

# Let the other pane sleep so shell does not interfere with tty input
tmux send-keys -t "$pane" "sleep 10000" Enter

gdb -ex "tty $tty_value"
