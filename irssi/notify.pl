# Notification system

use strict;
use vars qw($VERSION %IRSSI);

use Irssi;

$VERSION='1.00';

%IRSSI = (
    authors     => 'Julien Chaffraix',
    contact     => 'jchaffraix@chromium.org',
    name        => 'Notification',
    description => 'Notify when you name is mentioned',
    license     => 'Public Domain',
);

# FIXME: This methods needs a lot more testing!
sub notify {
    my ($server, $msg, $nick, $address, $target) = @_;
    my $myNick = $server->{nick};

    return if ($nick =~ $myNick);

    if (!$target or $target =~ $myNick) {
        my $summary = $target ? $target : $nick;
        my $body = $msg;
        exec("notify-send -t 1000 $summary $body");
    }
}

# Is 'print text' a better alternative to those 2
# messages? ($dest [$dest->{server}], $text, $stripped)
Irssi::signal_add('message public', 'notify');
Irssi::signal_add('message private', 'notify');
