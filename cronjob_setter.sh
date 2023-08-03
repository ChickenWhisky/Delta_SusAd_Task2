#!/bin/bash


cron_expression1="10 10 */3 * * && ./backup.sh"

day_of_month=$(date '+%d')

#Makes sure that it runs on sundays and at the same time it isnt the date is a multiple of 3
cron_expression2="10 10 * 5,6,8 0 [ $((day_of_month % 3)) -ne 0 ] && ./backup.sh"


# Add the cron job
(crontab -l 2>/dev/null; echo "$cron_expression1") | crontab -
(crontab -l 2>/dev/null; echo "$cron_expression2") | crontab -

echo "Cron job for database backup has been set up."
