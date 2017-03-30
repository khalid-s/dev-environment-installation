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
sudo apt-get install php apache2 mysql-server

# Install mongoDB

# Import the public key used by the package management system
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6
# Create a list file for MongoDB
echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list
# Reload local package database
sudo apt-get update -y
# Install the MongoDB packages
sudo apt-get install -y mongodb-org

#install mongoDB for php
sudo pecl install mongo

##Ajoutez la ligne suivante à votre fichier php.ini 
 echo -e "extension=mongodb.so" | sudo tee /etc/php/7.0/cli/php.ini

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
