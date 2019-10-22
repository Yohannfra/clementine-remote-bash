#!/bin/bash

# clementine-remote-bash is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# clementine-remote-bash is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this code. If not, see <http://www.gnu.org/licenses/>.

DBUSBASE="org.mpris.MediaPlayer2.clementine /org/mpris/MediaPlayer2"

# Check if clementine is running
function is_clementine_running()
{
    ps -A | grep "clementine" | grep -v "remo" > /dev/null
    status=$?
    if [ $status -ne 0 ]; then
        echo "clementine is not running"
        exit 1
    fi
}

# show usage
function usage()
{
    echo "usage: $(basename $0) -g <info-to-get>
    OPTIONS:
      -c    command

        commands can be:
          play
          pause
          playpause
          prev
          next

      -g    get info
      -h    list all commands

    examples:

      $(basename $0) -c play
      $(basename $0) -g title
      $(basename $0) -g status
    "
}

function runcmd()
{
    case $1 in
        next)
            qdbus $DBUSBASE org.mpris.MediaPlayer2.Player.Next
            ;;
        pause)
            qdbus $DBUSBASE org.mpris.MediaPlayer2.Player.Pause
            ;;
        play)
            qdbus $DBUSBASE org.mpris.MediaPlayer2.Player.Play
            ;;
        playpause)
            qdbus $DBUSBASE org.mpris.MediaPlayer2.Player.PlayPause
            ;;
        prev)
            qdbus $DBUSBASE org.mpris.MediaPlayer2.Player.Previous
            ;;
        shuffle)
            shuffle
            ;;
        *)
            echo "command $1 not known or not implemented"
            exit 1
            ;;
    esac
    return
}

function setvolume()
{
    qdbus $DBUSBASE org.freedesktop.DBus.Properties.Set org.mpris.MediaPlayer2.Player Volume $1
}

function shuffle()
{
    qdbus $DBUSBASE org.freedesktop.DBus.Properties.Set org.mpris.MediaPlayer2.Player Shuffle false
    sleep 1
    qdbus $DBUSBASE org.freedesktop.DBus.Properties.Set org.mpris.MediaPlayer2.Player Shuffle true
}

function getinfo()
{
    case $1 in
        artist)
            qdbus $DBUSBASE org.freedesktop.DBus.Properties.Get org.mpris.MediaPlayer2.Player Metadata | awk '/artist:/{$1=""; print substr($0,2)}'
            ;;
        position)
            qdbus $DBUSBASE org.freedesktop.DBus.Properties.Get org.mpris.MediaPlayer2.Player Position
            ;;
        shuffle)
            qdbus $DBUSBASE org.freedesktop.DBus.Properties.Get org.mpris.MediaPlayer2.Player Shuffle
            ;;
        status)
            qdbus $DBUSBASE org.freedesktop.DBus.Properties.Get org.mpris.MediaPlayer2.Player PlaybackStatus
            ;;
        title)
            qdbus $DBUSBASE org.freedesktop.DBus.Properties.Get org.mpris.MediaPlayer2.Player Metadata | awk '/title:/{$1=""; print substr($0,2)}'
            ;;
        volume)
            qdbus $DBUSBASE org.freedesktop.DBus.Properties.Get org.mpris.MediaPlayer2.Player Volume
            ;;
        *)
            echo "command $1 not known or not implemented"
            exit 1
            ;;
    esac
    return
}

function main()
{
    # check if clementine is running, the function exit if not
    is_clementine_running

    if [ $# -eq 0 ]; then
            usage
            exit 1
    fi
    # When you need an argument that needs a value, you put the ":" right after
    # the argument in the optstring. If your var is just a flag, withou any
    # additional argument, just leave the var, without the ":" following it.
    #
    # please keep letters in alphabetic order
    #
    while getopts ":c:g:hp:s:v:" OPTION
    do
        case $OPTION in
            c)
                runcmd "$OPTARG"
                ;;
            g)
                getinfo "$OPTARG"
                ;;
            h)
                usage
                exit 1
                ;;
            p)
                setplaylist "$OPTARG"
                ;;
            v)
                setvolume "$OPTARG"
                ;;
        esac
    done
}

main $@
