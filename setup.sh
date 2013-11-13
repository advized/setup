#!/bin/bash
# Simple setup.sh for configuring Ubuntu 10.04 LTS Linode instance
# for headless setup. 

#############
# Install git
#############
sudo apt-get install -y git


########################
# PostreSQL and PostGIS
########################

# Install PostgreSQL 9.2
echo "deb http://apt.postgresql.org/pub/repos/apt/ lucid-pgdg main" | sudo tee -a /etc/apt/sources.list.d/pgdg.list

wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | \
  sudo apt-key add -

sudo apt-get update
sudo apt-get install postgresql-9.2
sudo apt-get install postgresql-contrib-9.2
sudo apt-get install postgresql-server-dev-9.2 # Required for PostGIS
sudo passwd postgres # Update postgres default password
su postgres
psql -d template1 -c "ALTER USER postgres WITH PASSWORD 'changeme';" # replace change me by your password
sudo usermod -aG sudo postgres # will allow to manage /etc/init.d/postgresql 

#########
# PostGIS
#########

# Install PostGIS 2 or 1.5 from sources

# Install dependencies
sudo apt-get install libxml2-dev
# Geos: required for geometry function support
cd ~/installs/sources
wget http://download.osgeo.org/geos/geos-3.4.2.tar.bz2
tar -jxvf geos-3.4.2.tar.bz2
cd geos-3.4.2
./configure
make
sudo make install
# Install GDAL/OGR
cd ~/installs/sources
wget http://download.osgeo.org/gdal/1.10.1/gdal-1.10.1.tar.gz
tar xzf gdal-1.10.1.tar.gz
cd gdal-1.10.1
./configure
make
sudo make install
# Install JSON-C: required for GEOJSON support
sudo apt-get install libjson0 python-simplejson libjson0-dev
# Install PROJ
apt-get install proj-bin proj-data libproj-dev

# Finally install PostGIS 2.0
cd ~/installs/sources
wget http://download.osgeo.org/postgis/source/postgis-2.0.2.tar.gz
tar xzf postgis-2.0.2.tar.gz
cd postgis-2.0.2
./configure --with-raster --with-topology
make
sudo make install

# OR PostGIS 1.5
cd ~/installs/sources
wget http://download.osgeo.org/postgis/source/postgis-1.5.8.tar.gz
tar xzf postgis-1.5.8.tar.gz
cd postgis-1.5.8
./configure
make
sudo make install

# To add PostGIS features in a PostGres database (here CKAN database ckan_default with a ckan_default user)
sudo -u postgres psql -d ckan_default -f /usr/share/postgresql/9.2/contrib/postgis-1.5/postgis.sql
sudo -u postgres psql -d ckan_default -f /usr/share/postgresql/9.2/contrib/postgis-1.5/spatial_ref_sys.sql
ALTER TABLE spatial_ref_sys OWNER TO ckan_default;
ALTER TABLE geometry_columns OWNER TO ckan_default;


#################
# Tilemill 0.10.1
#################
# Note: As Tilemill 0.10.1 requires nodejs 0.8.11
# it's important to install proper nodejs version through this script
cd ~/installs
wget http://tilemill.s3.amazonaws.com/latest/install-tilemill.tar.gz
tar -zxvf install-tilemill.tar.gz
./install-tilemill.sh

#####################
# Python environment
#####################

# Required to install psycopg2 (requ module for PostgreSQL)
sudo apt-get install libpq-dev python-dev

# Install Python Setuptools
wget https://bitbucket.org/pypa/setuptools/raw/bootstrap/ez_setup.py
sudo python ez_setup.py

# Install Python pip
wget https://raw.github.com/pypa/pip/master/contrib/get-pip.py
sudo python get-pip.py

# Install virtualenv
sudo pip install virtualenv

##############
# Install CKAN
##############
# http://docs.ckan.org/en/latest/install-from-source.html


###################
# RAILS environment
###################
# Install rvm (ruby version manager)
# \ ensure that proper curl command is launced and not any alias
# \curl -L https://get.rvm.io | bash
# echo '[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"' >> ~/.bashrc
# . ~/.bashrc
# rvm get head && rvm reload
#
# Install ruby
# rvm install 1.9.3
#
# Create gemset (here rails3tutorial2nd)
# rvm use 1.9.3@rails3tutorial2nd --create --default
#
# Ensure 1.8.24 version of gem is used
# gem update --system 1.8.24
# 
# Specify that no local doc is required
# -e enable interpretation of backslash escapes
# echo -e "install: --no-rdoc --no-ri\nupdate: --no-rdoc --no-ri" > .gemrc
# 
# Install rails 3.2.3 gem
# gem install rails -v 3.2.3
# 
# 
# Install nginx web server
# sudo apt-get install nginx
# 
# 
# Install passenger gem to deploy rails through apache or nginx
# gem install passenger
# 
#  Run passenger-install-nginx-module and follow instructions (will compiled/install nginx with passenger)
#  Config virtual hosts (refer to setup/nginx)
#  Create an init script to manage nginx
#  wget -O init-deb.sh http://library.linode.com/assets/660-init-deb.sh
#  mv init-deb.sh /etc/init.d/nginx
#  chmod +x /etc/init.d/nginx
#  /usr/sbin/update-rc.d -f nginx defaults

#############
# node.js ###
#############
# Install node.js (only used for as js debugger for now) 
# sudo apt-get install -y python-software-properties python g++ make
# sudo add-apt-repository ppa:chris-lea/node.js
# sudo apt-get update
# sudo apt-get install -y nodejs
# sudo npm install -g jshint

# Install topojson package
# sudo npm install -g topojson

# Install Apache2
# sudo apt-get install apache2


# Sym link virtual hosts Apache config files
# cd /etc/apache2/sites-available
# sudo ln -s ~/setup/virtual_hosts_apache/advized.org
# sudo ln -s ~/setup/virtual_hosts_apache/backbone.advized.org
# sudo ln -s ~/setup/virtual_hosts_apache/bootstrap.advized.org
# sudo ln -s ~/setup/virtual_hosts_apache/course.advized.org
# sudo ln -s ~/setup/virtual_hosts_apache/blog.advized.org


# Sym link var/www to sites 
# cd /var/www
# sudo ln -s ~/sites/advized.org
# sudo ln -s ~/sites/backbone.advized.org
# sudo ln -s ~/sites/bootstrap.advized.org
# sudo ln -s ~/sites/course.advized.org
# sudo ln -s ~/sites/blog.advized.org


# Enable and reload sites 
# sudo a2ensite advized.org
# sudo a2ensite backbone.advized.org
# sudo a2ensite bootstrap.advized.org
# sudo a2ensite course.advized.org
# sudo a2ensite blog.advized.org
# Take care, I had to explicitly define APACHE_LOG_DIR 
# export APACHE_LOG_DIR=/var/log/apache2
# in /etc/apache2/envvars
# sudo /etc/init.d/apache2 reload


