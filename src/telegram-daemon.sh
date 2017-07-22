#! /bin/sh
### BEGIN INIT INFO
# Provides:          telegram-cli
# Required-Start:    $network $remote_fs $syslog
# Required-Stop:     $network $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Commandline interface for Telegram chat program
# Description:       Telegram-cli is a (unofficial) cli version of Telegram to chat from your console.
#                    This is an init script do make it a daemon.
#                    When used as daemon in conjuction  with LUA (scripting) you can use it to send your system
#                    commands to execute via other Telegram apps (PC - Phone - Web or other) while not
#                    logged in to the system.
#
#                    Note #1: This version of the init script is developed for raspbian (rapberry PI port of Debian Wheezy).
#
#
#                    See: https://github.com/vysheng/tg for more information.
#                    Derived from https://github.com/vysheng/tg/issues/436 (updated 9th April 2015)
#                    Further derived from: https://www.domoticz.com/wiki/Installing_Telegram_Notification_System#.2Fetc.2Finit.d.2Ftelegram-cli
### END INIT INFO


# Set some variables
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin
DESC="Telegram Messaging System"
NAME=telegram-cli
USERNAME=pi
GROUPNAME=pi
LOGFILE=/var/log/telegramd.log
DAEMON=/home/pi/tg/bin/telegram-cli
TGPORT=1234

TelegramKeyFile=/home/pi/tg/tg-server.pub
ReceiveLua=/home/pi/tg/alarmacutremur.lua

#DAEMON_ARGS="-W -b -U $USERNAME -G $GROUPNAME -k $TelegramKeyFile -L $LOGFILE -P $TGPORT -s $ReceiveLua -d -vvvRC"
#/home/pi/tg/bin/telegram-cli -k /home/pi/tg/tg-server.pub -W -s /home/pi/tg/alarmacutremur.lua -U pi -G pi
#DAEMON_ARGS=“-k $TelegramKeyFile -L $LOGFILE -P $TGPORT -s $ReceiveLua -d -vvvRC"


PIDFILE=/var/run/$NAME.pid
SCRIPTNAME=/etc/init.d/$NAME

# Read configuration variable file if it is present
[ -r /etc/default/$NAME ] && . /etc/default/$NAME

# Carry out specific functions when asked to by the system
case "$1" in

    start)
        echo -n "Starting $DESC ... "
        start-stop-daemon --start --background --make-pidfile $PIDFILE --pidfile $PIDFILE \
            --exec $DAEMON -- $DAEMON_ARGS || true
        echo "Done."
    ;;

    stop)
        echo -n "Stopping $DESC ... "
        start-stop-daemon --stop --retry 2 --pidfile $PIDFILE \
            --exec $DAEMON || true
    rm -f $PIDFILE
    echo "Done."

    ;;
    restart)
        echo -n "Restarting $DESC "
        start-stop-daemon --stop --retry 2 --pidfile $PIDFILE \
            --exec $DAEMON || true
        rm -f $PIDFILE
        start-stop-daemon --start --background --make-pidfile $PIDFILE --pidfile $PIDFILE \
            --exec $DAEMON -- $DAEMON_ARGS || true
        echo "Done."
    ;;

    status)
        if [ -f $PIDFILE ]; then
                PID=`cat $PIDFILE`
        else
                echo "No pid file, telegramd not running?"
                exit 1
        fi
        if [ "`ps -p $PID -o comm=`" = "telegram-cli" ]; then
                echo "telegramd running with pid $PID"
        else
                echo "telegramd not running. removing $PIDFILE"
                rm -f $PIDFILE
                exit 1
        fi
    ;;

    *)
        N=/etc/init.d/$NAME
        echo "Usage $NAME: $SCRIPTNAME {start|stop|restart|status}"
        exit 1
    ;;

esac
