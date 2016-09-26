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

# Make sure kernel is up to date before getting started
sudo add-apt-repository ppa:webupd8team/sublime-text-3
sudo apt-get update --fix-missing
sudo apt-get upgrade

# Install lamp-server PHP Apache MySQL
printf "${yellow}Looks like php is not installed. We'll install the whole lamp-server stack with tasksel${reset}\n"
sudo apt-get install tasksel
sudo tasksel install lamp-server

# Install ruby
sudo apt-get install ruby-full

# Install sass and compass
printf "${yellow}Looks like compass is not installed. We'll install compass using gem install compass${reset}\n"
sudo gem update
sudo gem install compass

printf "${green}We are now going to install a few stuffs for php${reset}\n"
# Install Curl and php5-curl (php5-curl gets enabled automatically)
# Install php5-cgi to launch install/index.php with params
sudo apt-get install php5-curl curl php5-gd php5-cgi php5-intl

printf "${yellow}We are now going to install phpmyadmin${reset}\n"
# Installing phpmyadmin as it is useful for devs
sudo apt-get install phpmyadmin

printf "${yellow}We are now going to install firefox developer edition${reset}\n"
# http://askubuntu.com/questions/548003/how-do-i-install-the-firefox-developer-edition
sudo add-apt-repository ppa:ubuntu-mozilla-daily/firefox-aurora
sudo apt-get update
sudo apt-get install firefox

# Composer bug lack of memory
# https://getcomposer.org/doc/articles/troubleshooting.md#proc-open-fork-failed-errors
sudo /bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=1024
sudo /sbin/mkswap /var/swap.1
sudo /sbin/swapon /var/swap.1

# Composer installation
printf "${yellow}Composer is not installed globally... We'll try to get it done :)${reset}\n"
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

if ! [ -x "$(command -v unzip)" ]; then
    printf "${yellow}Unzip is not installed. We'll install it using sudo apt-get install unzip :)${reset}\n"
    sudo apt-get install unzip
fi

# npm install bug
# This is a temporary fix as it will be fixed in npm#2.7
mkdir -p /home/$(whoami)/tmp
sudo chmod -R 777 /home/$(whoami)/tmp
# @todo to remove this hack as it may present a security issue

# Nodejs and npm installation
printf "${yellow}Looks like npm and nodejs are not installed... We'll give it a shot.${reset}\n"
sudo apt-get install npm nodejs-legacy

# Grunt and bower install
printf "${yellow}We are now going to install bower and grunt-cli globally${reset}\n"

# Install bower if was not installed
sudo npm install -g bower
# Symbolic link for bower as sometimes bugs
sudo ln -s /usr/bin/nodejs /usr/bin/node

# Install grunt-cli if was not installed
sudo npm install -g grunt-cli
echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p

