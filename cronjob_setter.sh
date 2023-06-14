#!/bin/bash


cron_expression="10 10 3,6,9,12,15,18,21,24,27,30 5,6,8 * [ \"\$(date '+\%a')\" = \"Sun\" ] && ./backup.sh"

# Add the cron job
(crontab -l 2>/dev/null; echo "$cron_expression") | crontab -

echo "Cron job for database backup has been set up."
