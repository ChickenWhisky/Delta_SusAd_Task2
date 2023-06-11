#!/bin/bash

# Imports required functions from the function.sh file
source /home/Delta_SusAd_Task1/SuperUser\ Mode/functions.sh

# Checks if the User is the HAD or a Student
user=$(whoami)
if [ "$user" = "HAD" ]; then
    checker="HAD"
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

declare -a capcityarray=(0 0 0)

if [ "$checker" = "student" ]; then

    #Checks if the Student has already submitted a preference

    hasStudentSubmittedYet="no"

    while read R P; do
        if [ $R = $rollno ]; then
            hasStudentSubmittedYet="yes"
            break
        else
            continue
        fi
    done </home/HAD/mess.txt

    if [ "$hasStudentSubmittedYet" = "no" ]; then

        # Prints out current mess capacity
        echo "Mess Capacity"
        while read -r MESS capacity; do
            if [ $MESS = 1 ]; then
                echo "$MESS $capacity"
                capcityarray[0]=$capacity
            elif [ $MESS = 2 ]; then
                echo "$MESS $capacity"
                capcityarray[1]=$capacity
            elif [ $MESS = 3 ]; then
                echo "$MESS $capacity"
                capcityarray[2]=$capacity
                break
            elif [ "$MESS" = "Mess" ]; then
                continue
            fi
        done </home/HAD/mess.txt

        echo Please enter your mess preference as a 3 digit numeral where each digit corresponds to the mess number

        # Checks whether the given string of numbers is a valid sequence of numbers
        # If not it keeps looping till it gets a correct value
        while true; do
            read Messpreference
            if [ "$Messpreference" = "123" ] || [ "$Messpreference" = "132" ] || [ "$Messpreference" = "213" ] || [ "$Messpreference" = "231" ] || [ "$Messpreference" = "321" ] || [ "$Messpreference" = "312" ]; then
                break

            else
                echo Invalid preference order. Please enter a valid preference order
            fi
        done

        #Appends the student mess preference to mess.txt
        echo "$rollno $Messpreference" >>/home/HAD/mess.txt

        #Rewrites the students userDetails.txt file with updated information
        echo 'name rollno dep hostel year room allocated_mess month mess_preference' >/home/$hostel/$room/$name/userDetails.txt
        echo "$name" "$rollno" "$department " "$hostel   " "$year   " "$room   " "$mess   " "$(date +%b)   " "$Messpreference" | tee -a /home/$hostel/$room/$name/userDetails.txt >/dev/null

    #If the student has already submitted a preference then it displays an error message
    else
        echo You have already submitted a preference.You cannot enter your preference order again.
    fi

################################  HAD SCRIPT  ##############################################

elif [ "$checker" = "HAD" ]; then

    # Starts reading from the 6th line of the mess.txt as the required info starts from line 6
    sed -n '6   ,$ p' /home/HAD/mess.txt | while read rollno pref; do

        # Splits the preference string into an array for easier use
        prefarray=($(echo $pref | sed 's/\(.\)/\1 /g'))

        # Colelcts more info about the student with the given rollno inorder to access their directory
        while read Name Rollno Hostel Room Mess Messpref; do
            if [ "$Rollno" = "$rollno" ]; then
                name=$Name
                room=$Room
                hostel=$Hostel
                Messpreference=$Messpref
                getDepartment
                getYear
                month=$(date +%b)

                break
            else
                continue
            fi
        done </home/Delta_SusAd_Task1/SuperUser\ Mode/src/studentDetails.txt

        # The following will append updated allocated mess data to the students userDetails.txt

        # $((${prefarray[0]} - 1)) will give us the index of the users first preference value in capacityarray
        if [ ${capcityarray[$((${prefarray[0]} - 1))]} -gt 0 ]; then

            echo "name rollno dep hostel year room allocated_mess month mess_preference" >"/home/$hostel/$room/$Name/userDetails.txt"
            echo "$name $rollno $department $hostel $year $room ${prefarray[0]} $month $Messpreference" >>"/home/$hostel/$room/$Name/userDetails.txt"

            capcityarray[$((${prefarray[0]} - 1))]=$((${capcityarray[$((${prefarray[0]} - 1))]} - 1))

        # $((${prefarray[1]} - 1)) will give us the index of the users 2nd preference value in capacityarray
        elif [ ${capcityarray[$((${prefarray[1]} - 1))]} -gt 0 ]; then

            echo "name rollno dep hostel year room allocated_mess month mess_preference" >"/home/$hostel/$room/$Name/userDetails.txt"
            echo "$name $rollno $department $hostel $year $room ${prefarray[1]}_mess $month $Messpreference " >>"/home/$hostel/$room/$Name/userDetails.txt"

            capcityarray[$((${prefarray[1]} - 1))]=$((${capcityarray[$((${prefarray[1]} - 1))]} - 1))

        # $((${prefarray[2]} - 1)) will give us the index of the users last preference value in capacityarray
        else

            echo "name rollno dep hostel year room allocated_mess month mess_preference" >"/home/$hostel/$room/$Name/userDetails.txt"
            echo "$name $rollno $department $hostel $year $room ${prefarray[2]} $month $Messpreference" >>"/home/$hostel/$room/$Name/userDetails.txt"

            capcityarray[$((${prefarray[2]} - 1))]=$((${capcityarray[$((${prefarray[2]} - 1))]} - 1))
        fi
    done

    # Updates the mess.txt with the current values of seating capacity
    sed -i "2s/[^[:space:]]\+/${capcityarray[0]}/2" "/home/HAD/mess.txt"
    sed -i "3s/[^[:space:]]\+/${capcityarray[1]}/2" "/home/HAD/mess.txt"
    sed -i "4s/[^[:space:]]\+/${capcityarray[2]}/2" "/home/HAD/mess.txt"
fi
