#!/usr/bin/env bash

sudo apt install apache2 -y
sudo a2enmod proxy
sudo a2enmod proxy_http
sudo ufw app list
sudo ufw allow in "Apache"
sudo mkdir /var/www/gamma-z.hm

sudo cp ./index.html /var/www/gamma-z.hm/index.html

sudo cp ./gamma-z.hm.conf /etc/apache2/sites-available/
sudo ln -s /etc/apache2/sites-available/gamma-z.hm.conf /etc/apache2/sites-enabled/gamma-z.hm.conf
sudo a2ensite gamma-z.hm.conf
sudo a2dissite 000-default.conf


echo "127.0.0.1 gamma-z.hm" | sudo tee -a /etc/hosts > /dev/null
sudo systemctl reload apache2
