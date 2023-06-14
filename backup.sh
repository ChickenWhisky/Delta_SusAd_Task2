#!/bin/bash

backup_dir="./db_backup"
timestamp=$(date +%Y-%m-%d_%H-%M-%S)
backup_file="$backup_dir/backup_$timestamp.sql"

docker exec -t delta_susad_task2-db-1 pg_dumpall -c -U postgres > "$backup_file"