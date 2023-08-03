#!/usr/bin/env bash

sudo apt install apache2 -y
sudo a2enmod proxy
sudo a2enmod proxy_http
sudo mkdir -p /var/www/gamma-z.hm

sudo chown -R $USER:$USER /var/www/gamma-z.hm
sudo chmod -R 755 /var/www

sudo cp ./gamma-z.hm.conf /etc/apache2/sites-available/
sudo ln -s /etc/apache2/sites-available/gamma-z.hm.conf /etc/apache2/sites-enabled/gamma-z.hm.conf

sudo a2ensite gamma-z.hm.conf
sudo a2dissite 000-default.conf
sudo /bin/sh -c 'echo "127.0.0.1       gamma-z.hm
127.0.0.1       www.gamma-z.hm" >> /etc/hosts'

sudo systemctl restart apache2
sudo chmod +x ./backup.sh
sudo chmod +x ./cronjob_setter.sh





