# Delta SysAd Task-1

Hello and welcome to my Delta Inductions Task 1 for the Sysad domain.
To begin open up the terminal and enter the following commands

## On Starting the server

* Open the terminal and enter the following block of code
```
sudo apt update
sudo apt -y upgrade
sudo apt install sudo acl wget git
sudo apt-get install at

```
* If the user HAD hasnt been created then do the following
```
sudo useradd -m -d /home/HAD HAD
cd /home/HAD
```

* Sign in to User HAD & execute the following on the terminal 

```
cd /home
git clone https://github.com/ChickenWhisky/Delta_SusAd_Task1.git
```

### Extra files for the sake of testing above scripts
* putongit.sh is a simple script that simplifies the process of pushing commits to github
* reset.sh is a script written to delete all users & directories created by genStudent.sh

### Normal Mode
- [X] genStudent.sh
- [X] permit.sh
- [X] updateDefaulter.sh
- [X] messAllocation.sh
- [X] feeBreakup.sh
### Superuser Mode
- [X] signOut.sh
