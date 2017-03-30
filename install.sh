#!/bin/bash

sudo locale-gen "fr_FR.UTF-8"
sudo dpkg-reconfigure locales

# Shell color variables
red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
blue=`tput setaf 4`
lightgrey=`tput setaf 6`
reset=`tput sgr0`

sudo mkdir -p /var/www/html

cd /var/www

# Resolved rights problems
sudo groupadd iknsa
sudo usermod -a -G iknsa www-data
sudo usermod -a -G iknsa $(whoami)
sudo chown -R $(whoami):iknsa /var/www
sudo chgrp -R iknsa /var/www

sudo apt install aptitude -y

# Install PHP Apache MySQL
printf "${yellow}Looks like php is not installed. We'll install the whole lamp-server stack with tasksel${reset}\n"

# Install apache2 
sudo apt-get update
sudo apt-get install apache2

# Install mysql
sudo apt-get install mysql-server -y

# Install php
sudo apt-get install php libapache2-mod-php php-mcrypt php-mysql
sudo apt-get install php-cli

sudo systemctl restart apache2

# Active rewrite
ls -l /usr/lib/apache2/modules/
sudo a2enmod rewrite

echo "<ifModule mod_rewrite.c> RewriteEngine On </ifModule>" | sudo tee /etc/apache2/apache2.conf
sudo /etc/init.d/apache2 restart

# Install ruby
sudo aptitude install ruby-full -y

# Install sass and compass
printf "${yellow}Looks like compass is not installed. We'll install compass using gem install compass${reset}\n"
sudo gem update
sudo gem install compass

printf "${green}We are now going to install a few stuffs for php${reset}\n"
# Install php5-curl (php5-curl gets enabled automatically)
sudo aptitude install curl php-curl php-gd php-cgi php-intl -y

printf "${yellow}We are now going to install phpmyadmin${reset}\n"
# Installing phpmyadmin as it is useful for devs
sudo aptitude install phpmyadmin -y

# Composer installation
printf "${yellow}Composer is not installed globally... We'll try to get it done :)${reset}\n"
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('SHA384', 'composer-setup.php') === '669656bab3166a7aff8a7506b8cb2d1c292f042046c5a994c43155c0be6190fa0355160742ab2e1c88d40d5be660b410') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"
sudo mv composer.phar /usr/local/bin/composer

# Nodejs and npm installation
printf "${yellow}Looks like npm and nodejs are not installed... We'll give it a shot.${reset}\n"
sudo aptitude install nodejs npm -y

# Grunt and bower install
printf "${yellow}We are now going to install bower and grunt-cli globally${reset}\n"

# Install bower if was not installed
sudo npm install -g bower
# Symbolic link for bower as sometimes bugs
# sudo ln -s /usr/bin/nodejs /usr/bin/node

# Install grunt-cli if was not installed
sudo npm install -g grunt-cli
# echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p
