#!/bin/bash
#
# socket_notify.rb example bash scripts
#
# Author: Christopher Giroir <kelsin@valefor.com>
#
# Example bash script that reads these notifications.
#
# To use this:
# * install terminal-notifiier
# * replace the icon paths
# * remove any terminal-notifier options that you don't like
# * replace the ssh host
#
# Then run "get-irc-notifications" in a terminal after loading this script.

function irc-notification {
  TYPE=$1
  MSG=$2

  terminal-notifier \
    -title IRC \
    -subtitle "$TYPE" \
    -message "$MSG" \
    -appIcon ~/path/to/icon.png \
    -contentImage ~/path/to/icon.png \
    -execute "/usr/local/bin/tmux select-window -t 0:IRC" \
    -activate com.apple.Terminal \
    -sound default \
    -group IRC
}

function get-irc-notifications {
  ssh remote.host.net 'nc -k -l -U /tmp/weechat.notify.sock' | \
    while read type message; do
      irc-notification "$(echo -n $type | base64 -D -)" "$(echo -n $message | base64 -D -)"
    done
}
