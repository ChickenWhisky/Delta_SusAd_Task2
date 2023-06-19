#!/bin/bash


cron_expression1="0 0 */3 5,6,8 * [ \"\$(date '+\%a')\" = \"Sun\" ] && ./backup.sh"

#Makes sure that it runs on sundays and at the same time it isnt the date is a multiple of 3
cron_expression2="0 0 * 1,2,6 * [ "$(date '+\%a' -d tomorrow)" == "Sun" ] && [ "$(date '+\%m')" != "03" ] && ./backup.sh"


# Add the cron job
(crontab -l 2>/dev/null; echo "$cron_expression1") | crontab -
(crontab -l 2>/dev/null; echo "$cron_expression2") | crontab -

echo "Cron job for database backup has been set up."
