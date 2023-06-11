#!/bin/sh
#A script to automate the deletion process for the sake of testing

sudo rm -r /home/Delta_SusAd_Task1

for i in 'GarnetA' 'GarnetB' 'Opal' 'Agate' 'HAD'
do
    sudo rm -r /home/$i
    sudo userdel $i
    sudo groupdel $i

done


while read name rollno hostel room mess messpref
do
    sudo userdel $name
    sudo groupdel $name

done < /home/thomas/Desktop/Sysad/Task1/NormalUser\ Mode/src/studentDetails.txt
