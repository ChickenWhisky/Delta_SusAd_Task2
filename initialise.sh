#!/usr/bin/env bash

sudo apt install apache2 -y
sudo a2enmod proxy
sudo a2enmod proxy_http

cp ./gamma-z.hm.conf /etc/apache2/sites-available/
sudo ln -s /etc/apache2/sites-available/gamma-z.hm.conf /etc/apache2/sites-enabled/gamma-z.hm.conf

echo "127.0.0.1 gamma-z.hm" | sudo tee -a /etc/hosts > /dev/null
sudo systemctl restart apache2