# pieqa
Pi Earthquake Alarm

amixer  sset PCM,0 100%

http://www.instructables.com/id/Raspberry-remote-control-with-Telegram/
http://www.instructables.com/id/Telegram-on-Raspberry-Pi/

run telegram as daemon
https://github.com/vysheng/tg/issues/373


copy telegram-daemon to /etc/init.d
sudo systemctl daemon-reload
sudo systemctl start telegram-daemon

