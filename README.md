# Delta SysAd Task-2

Hello and welcome to my Delta Inductions Task 2 for the Sysad domain.
To begin open up the terminal and enter the following commands

## Setup

To initialise the reverse proxy and server mess.txt 
```bash
$ chmod +x ./initialise.sh
$ ./initialise.sh
```

To activate the server and setup phpadmin and the userdetails website
```bash
$ docker compose up --build
```

To add data to the Postgress database
```bash
$ python3 ./add_data_to_db.py
```
To run the cronjob to back up data periodically
```bash
$ ./cronjob_setter.sh
```

### Normal Mode
- [X] Dockerise Task 1
    - [X] Display the file using Apache from the local directory of the docker container. Proxy the requests to the container.
    - [X] Make the file accessible locally using gamma-z.hm instead of default localhost. Opening gamma-z.hm should display the text file directly.
- [X] Store user details in Database
    - [X] Create a database to store all the user details instead of the files in the students' directory.
    - [X] Dockerise the database along with the server. Use docker-compose.
### Superuser Mode
- [ ] Setup a cronjob to periodically take database backup. The backup should take place at 10:10 every three days of month and on sundays for May, June and August. Do not setup multiple cronjobs.
- [X] Modify the docker setup to ensure that restarting docker will not destroy the data from database.
- [X] Add PHPMyAdmin docker service for viewing the database. Also create an account in PHPMyAdmin with read-only permissions to read the user details in the DB.
- [X] Create a website to display the user details based on their permissions.
    - [X] Implement login feature with userid and password. Get the permissions based on the logged in userid.
    - [X] HAD should be able to see everyone's details.
    - [X] Wardens should be able to see only their hostel's student's details.
    - [X] Students should only be able to see their own details.