#!/bin/bash

# Add all wardens to the primary groups of each student in their hostel and change each students group permissions to rwx
# Add add HAD to the primary groups of each student to rwx
# Add all students to their hostel wardens primary group
# Change permissions using ACL for announcment.txt,feeDefaulter.txt by allowing people of a the hostel warden group to acces it
# Add all students to a student group and give them access to mess.txt in HAD file using ACL

while read name rollno hostel room mess messpref; do
    if [ "$name" = "Name" ]; then
        continue
    else
        sudo usermod -a -G $hostel $name
        sudo usermod -a -G HAD $name
        sudo usermod -a -G $name $hostel
        sudo usermod -a -G $name HAD
        sudo setfacl -m "g:$name:rwx" /home/$hostel/$room/$name
        sudo setfacl -m "g:$name:rwx" /home/$hostel/$room/$name/userDetails.txt
        sudo setfacl -m "g:$name:rwx" /home/$hostel/$room/$name/fees.txt
        sudo setfacl -m "g:$name:r-x" /home/$hostel/$room/$name/messAllocation.sh
        sudo setfacl -m "g:$name:r-x" /home/$hostel/$room/$name/signOut.sh
        sudo setfacl -m "g:$name:r-x" /home/$hostel/$room/$name/feeBreakup.sh
        sudo setfacl -m "g:$name:rwx" /home/$hostel/$room/$name/signOutApproval.txt

    fi

done </home/Delta_SusAd_Task1/SuperUser\ Mode/src/studentDetails.txt

for i in 'GarnetA' 'GarnetB' 'Opal' 'Agate'; do

    sudo chmod 750 /home/$i
    sudo chmod 700 /home/$i/signOutDefaulters.txt
    sudo chmod 700 /home/$i/signOutHistory.txt
    sudo chmod 700 /home/$i/signOutRequests.txt

    sudo setfacl -m "g:$i:r-x" /home/$i/announcements.txt
    sudo setfacl -m "g:$i:r-x" /home/$i/signOutDefaulters.txt
    sudo setfacl -m "g:$i:r-x" /home/$i/feeDefaulters.txt
    sudo setfacl -m "g:$i:-w-" /home/$i/signOutRequests.txt
    sudo setfacl -m "u:$i:r-x" /home/$i/signOut.sh


    sudo setfacl -m "u:HAD:rwx" /home/$i/signOutDefaulters.txt
    sudo setfacl -m "u:HAD:rwx" /home/$i/announcements.txt
    sudo setfacl -m "u:HAD:rwx" /home/$i/feeDefaulters.txt
    sudo setfacl -m "u:HAD:rwx" /home/$i/signOutHistory.txt
    sudo setfacl -m "u:HAD:rwx" /home/$i/signOutRequests.txt
    sudo setfacl -m "u:HAD:rwx" /home/$i

    sudo setfacl -m "u:$i:rwx" /home/$i/signOutRequests.txt
    sudo setfacl -m "u:$i:rwx" /home/$i/signOutHistory.txt



    sudo usermod -a -G $i HAD

done

sudo chmod 750 /home/HAD
sudo setfacl -m "g:HAD:rwx" /home/HAD/mess.txt
sudo setfacl -m "g:HAD:r-x" /home/HAD/messAllocation.sh
sudo setfacl -m "g:HAD:r-x" /home/HAD/updateDefaulter.sh
