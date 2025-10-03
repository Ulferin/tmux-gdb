# Tmux debugging configuration script for GDB
This script allows to automatically create an extra pane and set a program's
output from inside GDB to be redirected to the newly created pane.

## Prerequisites
Define the following environment variable:
- `GDB_TMUX_FILE`: defines the path of the file used by the new pane to append
    the output of `tty` command from inside that pane. This is necessary to
    retrieve the tty device for redirecting the program's output from inside
    GDB.

Add this line to your shell config:
```sh
echo $TMUX_PANE > $GDB_TMUX_FILE
```
> [!NOTE]
> This is necessary to retrieve the newly created tmux pane's unique ID.

## References
- [ShaneKirk blog post](http://shanekirk.com/2017/08/gdb-tips-and-tricks-1-a-tale-of-two-terminals/)
- [gdb-dashboard](https://github.com/cyrus-and/gdb-dashboard/wiki/Use-multiple-terminals)
