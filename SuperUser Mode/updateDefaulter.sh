#!/bin/bash

user=$(whoami)
if [ "$user" = "HAD" ]; then
    countTo5=0
    while read name rollno hostel room mess messpref; do

        # Read the first line & last line of the file
        firstLine=$(head -n 1 /home/$hostel/$room/$name/fees.txt)
        lastTransaction=$(tail -n 1 /home/$hostel/$room/$name/fees.txt)

        # Extract the number after "CummulativeAmount= "
        num=$(echo "$firstLine" | sed -n 's/^.*cumulativeAmountPaid= //p')

        #Gets the epoch time mentioned in the latest transaction
        comparableTransaction=$(echo "$lastTransaction" | awk '{print $NF}')

        #Sets epoch time for end of sem
        endOfSem="2023-06-10 00:00:00"
        endOfSemEpoch=$(date --date="$endOfSem" +"%s")

        # Check if the cummulativeAmmountPaid is equal to 100000
        if [ $num -eq 100000 ] && [ $comparableTransaction -le $endOfSemEpoch ] && [ $countTo5 -lt 5 ]; then
            echo "$name" | tee -a /home/$hostel/announcements.txt > /dev/null
            if [ "$previousHostel" = "$hostel" ]; then
                countTo5=$(($countTo5 + 1))
            else
                countTo5=0
            fi

            previousHostel=$hostel
        else
            echo "$name" | tee -a /home/$hostel/feeDefaulters.txt > /dev/null

        fi
    done </home/Delta_SusAd_Task1/SuperUser\ Mode/src/studentDetails.txt

fi
