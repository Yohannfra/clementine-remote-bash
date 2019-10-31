# clementine-remote-bash
Bash script for remote control of clementine music player

## About Clementine Remote Bash
clementine-remote enables you to remote control Clementine from a bash terminal on the same computer clementine is running on. This is useful for automation tasks.

## Installation
#### Prerequisites
   * qdbus

#### Debian / Ubuntu
```
sudo apt-get install qdbus
```

## Usage
```
usage: clementine-remote-bash.sh -g <info-to-get>

OPTIONS:
  -c    command

    commands can be:
      play
      pause
      next
      prev

  -g    get info
  -h    list all commands

examples:

  clementine-remote-bash.sh -c play
  clementine-remote-bash.sh -g title
  clementine-remote-bash.sh -g status
```

## How i use it
I use this script along with i3wm to be able to control clementine from shortcuts.

In my i3/config:
```
bindsym $mod+Home exec --no-startup-id clementine-remote -c prev
bindsym $mod+End exec --no-startup-id clementine-remote -c playpause
bindsym $mod+Insert exec --no-startup-id clementine-remote -c next
```

I also use it to display the name of the song currently playing in my i3status bar.
https://github.com/Yohannfra/dotfiles/blob/master/i3/my_new_status


## Useful links and background info
### about dbus
   * [Controlling Clementine from command line with DBus and MPRIS](https://github.com/clementine-player/Clementine/wiki/Controlling-Clementine-from-the-commandline-with-DBus-and-MPRIS)


## License
clementine-remote-bash is free software, available under the [GNU General Public License, Version 3](http://www.gnu.org/licenses/gpl.html).

## Authors and Acknowledgments
Based on the [bash script](https://github.com/mgafner/clementine-remote-bash/blob/master/clementine-remote-bash.sh) of [mgafner](https://github.com/mgafner)
