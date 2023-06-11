#!/bin/bash

getDepartment() {
    local dep=$(cut --characters=2-3 <<<"$rollno")
    case $dep in
    06) department="CSE" ;;
    02) department="CHE" ;;
    03) department="CIV" ;;
    07) department="EEE" ;;
    08) department="ECE" ;;
    10) department="ICE" ;;
    11) department="MEC" ;;
    12) department="MME" ;;
    14) department="PRO" ;;
    01) department="ARC" ;;
    *) echo "InvalidDept" ;;
    esac
}

getYear() {

    # Slices the 5th and 6th digits of the roll number in order to calculate the students current year
    local Year=$(cut --characters=5-6 <<<"$rollno")
    local currentyear=$(date +%y)
    year=$(($currentyear - $Year + 1))

}

addusers() {
    
    # Students users are created and a default password is set for the sake of testing
    sudo useradd -m -d /home/$hostel/$room/$name $name >/dev/null
    echo "$name:password" | sudo chpasswd
    getDepartment
    getYear
    
    # Rerquired files are created in the students directory 
    sudo touch /home/$hostel/$room/$name/userDetails.txt
    sudo touch /home/$hostel/$room/$name/fees.txt
    sudo touch /home/$hostel/$room/$name/signOutApproval.txt

    # Required data is appended into the appropraite files in the students directory
    echo 'Return_date Approval_status' | sudo tee -a /home/$hostel/$room/$name/signOutApproval.txt >/dev/null
    echo 'name rollno department hostel year room allocated_mess month mess_preference' | sudo tee -a /home/$hostel/$room/$name/userDetails.txt >/dev/null
    echo "$name" "$rollno" "$department" "$hostel" "$year" "$room" "$mess" "$(date +%b)" "$messpref" | sudo tee -a /home/$hostel/$room/$name/userDetails.txt >/dev/null
    echo 'cumulativeAmountPaid= 0' | sudo tee -a /home/$hostel/$room/$name/fees.txt >/dev/null

    # Copying in other scripts that students will run for fee payment and submitting mess preferences 
    sudo cp /home/Delta_SusAd_Task1/SuperUser\ Mode/messAllocation.sh /home/$hostel/$room/$name/messAllocation.sh
    sudo cp /home/Delta_SusAd_Task1/SuperUser\ Mode/feeBreakup.sh /home/$hostel/$room/$name/feeBreakup.sh
    sudo cp /home/Delta_SusAd_Task1/SuperUser\ Mode/signOut.sh /home/$hostel/$room/$name/signOut.sh

    # Adding a link for announcements.txt and feeDefaulter.txt
    sudo ln -s "/home/$hostel/announcements.txt" "/home/$hostel/$room/$name/Announcement"
    sudo ln -s "/home/$hostel/feeDefaulters.txt" "/home/$hostel/$room/$name/Fee Defaulters"


    # A message is displayed on the student being generated
    echo "User $name has been generated"
}

addhostels() {

    # HAD user is created and its password is changed to HAD
    sudo useradd -m -d /home/HAD HAD >/dev/null
    echo "HAD:HAD" | sudo chpasswd
    
    # Required files are copied from the main source file i.e Delta_SusAd_Task1 into the HAD's directory 
    sudo cp /home/Delta_SusAd_Task1/SuperUser\ Mode/src/mess.txt /home/HAD/mess.txt
    sudo cp /home/Delta_SusAd_Task1/SuperUser\ Mode/messAllocation.sh /home/HAD/messAllocation.sh
    sudo cp /home/Delta_SusAd_Task1/SuperUser\ Mode/updateDefaulter.sh /home/HAD/updateDefaulter.sh


    # Hostel warden users are created and the required files are created in them and their passwords are changed to their hostel name
    for i in 'GarnetA' 'GarnetB' 'Opal' 'Agate'; do    
        sudo useradd -m -d /home/$i $i
        echo "$i:$i" | sudo chpasswd
        sudo touch /home/$i/announcements.txt
        sudo touch /home/$i/feeDefaulters.txt
        sudo touch /home/$i/signOutHistory.txt
        sudo touch /home/$i/signOutRequests.txt
        sudo touch /home/$i/signOutDefaulters.txt
        sudo cp /home/Delta_SusAd_Task1/SuperUser\ Mode/signOut.sh /home/$i/signOut.sh
        echo 'Name Room RollNumber ReturnDate' | sudo tee -a /home/$i/signOutApproval.txt >/dev/null
        echo 'Name Room RollNumber ReturnDate' | sudo tee -a /home/$i/signOutHistory.txt >/dev/null
        echo 'Name dateReturned approvedReturnDate' | sudo tee -a /home/$i/signOutDefaulters.txt >/dev/null

    done
}
