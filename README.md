# socket_notify.rb

Send highlights and private message to a unix socket

## Usage

### Installing

Place the script at `~/.weechat/ruby/socket_notify.rb` and symlink into
`~/.weechat/ruby/autoload` if you want it to load on startup.

Then load it in weechat by running:

    /script load socket_notify.rb

### Reading Notifications

On my macbook I turn these notifications into
[OS X Notification Center](http://support.apple.com/kb/ht5362) messages by using
the [terminal-notifier](https://github.com/alloy/terminal-notifier) app that I
installed (with [homebrew](http://brew.sh/)) by running:

    brew install terminal-notifier

Then I read and react to these notifications with the follow bash functions:

Change localhost to the remote machine where weechat is running

    WEEHOST=localhost

    function irc-notification {
      TYPE=$1
      MSG=$2

      terminal-notifier \
        -title IRC \
        -subtitle "$TYPE" \
        -message "$MSG" \
        -appIcon ~/share/weechat.png \
        -contentImage ~/share/weechat.png \
        -execute "/usr/local/bin/tmux select-window -t 0:IRC" \
        -activate com.apple.Terminal \
        -sound default \
        -group IRC
    }

    function get-irc-notifications {
      ssh $WEEHOST 'killall nc ; rm -rf /tmp/weechat.notify.sock ; nc -k -l -U /tmp/weechat.notify.sock' | \
        while read type message; do
          irc-notification "$(echo -n $type | base64 -D -)" "$(echo -n $message | base64 -D -)"
        done
    }

## Details

Whenever weechat gets a private message or a highlight this script will write a
short description and the message to the `/tmp/weechat.notify.socket` unix
socket if it exists. If the socket doesn't exist or isn't currently listening
then this script does nothing.

The message written is in the form:

    <Base64 Description> <Base64 Message>

I chose to do this since it made reading the message with bash scripts really
easy. You can read one line at a time from the socket and split on space to get
both items. Please let me know if there are any other good uses for this that
you come up with!
