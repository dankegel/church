# "Dazzle" church web site

## Setting up virtual development environment

The standard development environment is delivered as a (very large, almost
too large to download) .vdi file containing a copy
of ubuntu 14.04 with system apache/mysql/php installed,
and a copy of the site already configured.

To run it:

* copy the .vdi file onto your desktop,
* install Virtualbox (from http://virtualbox.org),
* select New / Linux / Existing disk, and point it to your copy of the .vdi file.
* in Settings, pick 768MB of RAM, 2 CPUs, and Bridged networking.
* Power on the virtual machine, and you should see a virtual desktop ready to use.


The site's source is kept in the directory ~/src/uusm in git
and is live on this site's web server; you can immediately see changes
without having to upload.

To view the virtual site from your own computer's web browser,
find out the virtual machine's IP address by doing
  ifconfig eth0
inside a terminal window.  You should be able to just type that
into your browser.  (Make sure you set the virtual machine for
bridged networking rather than NAT, though.)

## Forking the repo at Github

Once you've verified all that's working, in a web browser:

* Get an account at <http://github.com>,
* Read github's doc and the tutorial <http://readwrite.com/2013/09/30/understanding-github-a-journey-for-beginners-part-1>
* Add an SSH key to your account per <https://help.github.com/articles/generating-ssh-keys>
* Fork the repo <https://github.com/dankegel/church>
* Edit ~/src/uusm/.git/config and replace https://github.com/dankegel/church
with the git cloning URL of your own fork
* git pull

You should now be ready to commit changes to your own fork, and submit pull requests for review.

## Workflow

Our suggested workflow is documented at <https://github.com/dankegel/droogflow>
