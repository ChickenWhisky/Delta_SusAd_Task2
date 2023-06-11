#!/bin/bash


exec 4<&0

# Imports required functions from the function.sh file
source /home/Delta_SusAd_Task1/SuperUser\ Mode/functions.sh

#Function for checking if the student has logged in before the given return date
signOutDefaulterChecker() {
    lastlogin=$(last -1 $name | awk '{print $5 " " $6}')
    reformatted_date=$(date -d "$date" +"%m%d")
    reformatted_lastlogin=$(date -d "$lastlogin" +"%m%d")

    if [ $lastlogin -gt $reformatted_date ];then
        echo "$name $lastlogin $date" >> "/home/$user/signOutDefaulters.txt"
    fi
}
# Checks if the User is a Warden or a Student
user=$(whoami)
if [ "$user" = "GarnetA" ] || [ "$user" = "GarnetB" ] || [ "$user" = "Opal" ] || [ "$user" = "Agate" ]; then
    checker="Warden"
else
    while read Name Rollno Hostel Room Mess messpref; do
        if [ "$user" = "$Name" ]; then
            checker="student"
            name=$Name
            rollno=$Rollno
            hostel=$Hostel
            room=$Room
            mess=$Mess
            getDepartment
            getYear
            break
        else
            continue
        fi
    done </home/Delta_SusAd_Task1/SuperUser\ Mode/src/studentDetails.txt
fi

########################################  STUDENT SCRIPT  ##############################################

if [ "$checker" = "student" ]; then

    printf "\n                   SIGN OUT FORM \n\n"
    echo "Please enter the date you would like to return to the campus (!!Please enter the date in a yy-mm-dd format!!) :"

    while true; do
        read returnDate
        if [[ $returnDate =~ ^[0-9]{2}-[0-9]{2}-[0-9]{2}$ ]]; then
            break
        else
            echo Please enter a valid date
            continue
        fi
    done

    echo "$name $room $rollno $returnDate" >> "/home/$hostel/signOutRequests.txt"



########################################## HAD SCRIPT ######################################################

elif [ "$checker" = "Warden" ];then
    
    while read name room rollno date;do
        printf "$name   $rollno    $date \n"
        printf "Would you like to approve this particular signout request?[y/n] \n"
        read approval <&4
        if [ "$approval" = "y" ];then
            echo "$name $rollno $date" >> "/home/$user/signOutHistory.txt"
            echo "$date approved" >> "/home/$user/$room/$name/signOutApproval.txt"
            formatted_date=$(date -d "$date" +"%m%d%y")
            reformatted_date=$(date -d "$date" +"%m%d")
            echo "signOutDefaulterChecker" | at 23:59 $formatted_date


        else
            echo "$date declined" >> "/home/$user/$room/$name/signOutApproval.txt"

        fi
    done < /home/$user/signOutRequests.txt

fi
