#!/bin/sh
#
# Script to do administrative tasks for the church site

cmd=$1

projdir="`dirname $0`"
projdir="`cd "$projdir/.."; pwd`"

# Don't use this password if your MySQL server is on the public internet
sqlrootpw="q9z7a1"

# Ubuntu packages we need to install and uninstall in order to
# reproduce everything cleanly.
pkgs="mysql-client mysql-server drush php5-gd apache2 libapache2-mod-php5 ssmtp"

do_deps() {
    # FIXME: move secrets to ~/secrets.dat rathern than hardcoding them
    # or asking user to edit random files
    # And use debconf to suppress that password prompt; see
    # http://askubuntu.com/questions/79257/how-do-i-install-mysql-without-a-password-prompt

    echo "When prompted, enter $sqlrootpw for the sql root password."
    sleep 4
    set -x
    sudo apt-get install -y $pkgs

    # Configure ssmtp
    sudo tee /etc/ssmtp/ssmtp.conf <<_EOF_
root=postmaster
UseSTARTTLS=YES
hostname=`hostname`
# Edit the following lines
mailhub=mail.church.org
RewriteDomain=church.org
AuthUser=you@church.org
AuthPass=XXXXXXXX
_EOF_

    echo "Adding $LOGNAME to mail group.  Won't take effect until next login."
    sudo useradd -G mail $LOGNAME

    echo "Template created in /etc/ssmtp/ssmtp.conf.  Please edit it,"
    echo "log out and back in, and make sure you can send mail using /usr/sbin/sendmail."
}

do_install() {
    cd "$projdir"

    if test -f sites/defaults/settings.php
    then
        echo "Already installed, aborting"
        exit 1
    fi

    # Note: older versions of drush didn't need the 'standard' word
    drush si standard --site-name=Church --db-url=mysql://root:$sqlrootpw@localhost/drupal --account-name=drupal --account-pass=drupal

    # FIXME: This is insecure, but required to pass the status report tests
    chmod 777 sites/default/files

    # Support both Ubuntu 12.04 and 14.04?
    wwwdir=/var/www
    if test -d /var/www/html
    then
        wwwdir=/var/www/html
    fi

    sudo mv $wwwdir $wwwdir.bak.$$
    sudo ln -s "$projdir" $wwwdir
    sudo a2enmod rewrite

    # https://drupal.org/getting-started/clean-urls
    sudo tee /etc/apache2/conf-enabled/church.conf > /dev/null <<_EOF_
<Directory /var/www/html/church-tools>
    Options -Indexes +FollowSymLinks
    AllowOverride None
    Order allow,deny
    deny from all
</Directory>
<Directory /var/www/html>
    RewriteEngine on
    RewriteBase /
    RewriteCond %{REQUEST_FILENAME} !-f
    RewriteCond %{REQUEST_FILENAME} !-d
    RewriteCond %{REQUEST_URI} !=/favicon.ico
    RewriteRule ^ index.php [L]
</Directory>
_EOF_
    sudo service apache2 restart
    # You may also need to set base_url in sites/default/settings.php
}

usage() {
    cat <<_EOF_
Usage: $0 deps|install
_EOF_
}

case $1 in
deps) do_deps;;
install) do_install;;
*) usage; exit 1;;
esac
