Dev environment installation
============================

The installer will install the following:
* tasksel
* lamp-server
* php5-curl curl php5-gd php5-cgi php5-intl
* phpmyadmin
* Firefox developer edition
* composer
* ruby-full
* compass
* nodejs-legacy
* npm
* bower
* grunt

## If your environment is not configured you can use the following bash file to install the required packages for this course:

```
git clone https://github.com/khalid-s/dev-environment-installation.git ~
```

Go to the installation folder
```
cd ~/dev-environment-installation
```

Then launch the install bash file 
```
./install.sh
```

during the installation process set a password equal to 'paris' for MySQL

## This installation process is for first time installation on  fresh ubuntu.

For ease purpose set all passwords to paris. You will be able to change your password later for production.

If you choose another password for mysql then be careful not to take the default password paris when the app is being installed
