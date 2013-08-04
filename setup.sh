#!/bin/bash
# Simple setup.sh for configuring Ubuntu 10.04 LTS Linode instance
# for headless setup. 

# Install git
sudo apt-get install -y git

# Install Apache2
sudo apt-get install apache2

# Sym link virtual hosts Apache config files
cd /etc/apache2/sites-available
sudo ln -s ~/setup/virtual_hosts_apache/advized.org
sudo ln -s ~/setup/virtual_hosts_apache/backbone.advized.org
sudo ln -s ~/setup/virtual_hosts_apache/bootstrap.advized.org
sudo ln -s ~/setup/virtual_hosts_apache/course.advized.org
sudo ln -s ~/setup/virtual_hosts_apache/blog.advized.org

# Sym link var/www to sites 
cd /var/www
sudo ln -s ~/sites/advized.org
sudo ln -s ~/sites/backbone.advized.org
sudo ln -s ~/sites/bootstrap.advized.org
sudo ln -s ~/sites/course.advized.org
sudo ln -s ~/sites/blog.advized.org

# Enable and reload sites 
sudo a2ensite advized.org
sudo a2ensite backbone.advized.org
sudo a2ensite bootstrap.advized.org
sudo a2ensite course.advized.org
sudo a2ensite blog.advized.org
# Take care, I had to explicitly define APACHE_LOG_DIR 
# export APACHE_LOG_DIR=/var/log/apache2
# in /etc/apache2/envvars
sudo /etc/init.d/apache2 reload

# Install node.js (only used for as js debugger for now) 
sudo apt-get install -y python-software-properties python g++ make
sudo add-apt-repository ppa:chris-lea/node.js
sudo apt-get update
sudo apt-get install -y nodejs
sudo npm install -g jshint





# Install nvm: node-version manager
# https://github.com/creationix/nvm
#sudo apt-get install -y git
#sudo apt-get install -y curl
#curl https://raw.github.com/creationix/nvm/master/install.sh | sh

# Load nvm and install latest production node
#source $HOME/.nvm/nvm.sh
#nvm install v0.10.12
#nvm use v0.10.12

# Install jshint to allow checking of JS code within emacs
# http://jshint.com/
#npm install -g jshint

# Install rlwrap to provide libreadline features with node
# See: http://nodejs.org/api/repl.html#repl_repl
#sudo apt-get install -y rlwrap

# Install emacs24
# https://launchpad.net/~cassou/+archive/emacs
#sudo apt-add-repository -y ppa:cassou/emacs
#sudo apt-get -qq update
#sudo apt-get install -y emacs24-nox emacs24-el emacs24-common-non-dfsg

# Install Heroku toolbelt
# https://toolbelt.heroku.com/debian
#wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sh

# git pull and install dotfiles as well
# cd $HOME
# if [ -d ./dotfiles/ ]; then
#    mv dotfiles dotfiles.old
# fi
# if [ -d .emacs.d/ ]; then
#    mv .emacs.d .emacs.d~
# fi
# git clone https://github.com/startup-class/dotfiles.git
# ln -sb dotfiles/.screenrc .
# ln -sb dotfiles/.bash_profile .
# ln -sb dotfiles/.bashrc .
# ln -sb dotfiles/.bashrc_custom .
# ln -sf dotfiles/.emacs.d .

