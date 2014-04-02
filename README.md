qf-buildbot
===========

Script to setup and run a QFusion buildbot on Debian 7.4 amd64

Installing the vagrant vm
=========================

An up to date, prebuilt vm can be installed using

```
    $ vagrant init kalhartt/wswbot
    $ vagrant up
```

Alternately, if you would like to setup the vm yourself, simply

```
    $ vagrant init chef/debian-7.4
    $ vagrant up && vagrant ssh
    $ sudo apt-get install git
    $ git clone http://github.com/MGXRace/qf-buildbot
    $ cd qf-buildbot/scripts
    $ . setup.sh
```

Building Warsow or qfusion
==========================

To build qfusion

```
    $ vagrant up && vagrant ssh
    $ cd qf-buildbot/scripts
    $ . compile.sh
```

Or to build warsow

```
    $ vagrant up && vagrant ssh
    $ cd qf-buildbot/scripts
    $ . compile.sh warsow
```
