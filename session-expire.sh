#!/bin/sh

# --------------------
# Leonardo A Carrilho
# 2020, Dec 12
# Delete the session file after "n" minutes without activity 

minutesToExpire=10
path="/var/www/cgi-bin/kdvc"
sudo find $path/session -name "SESS_"* -amin +$minutesToExpire -delete
# Output to log
echo "[$(date +"%d-%m-%y %H:%m")] script executado." >> log/log-session-expire

# Obs: That "+" signal means, major than (>)
# Obs2: This script must be scheduled to run every 1 min in crontab
