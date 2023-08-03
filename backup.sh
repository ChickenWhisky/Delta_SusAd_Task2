#!/bin/bash

backup_dir="./db_backup"
timestamp=$(date +%Y-%m-%d_%H-%M-%S)
backup_file="$backup_dir/backup_$timestamp.sql"

# Here we run the database container in tty mode and request docker to kind of dump the 
docker exec -t delta_susad_task2-db-1 pg_dumpall -c -U postgres > "$backup_file"