# DevEnvironment Vagrant

Configuration for [vagrant](http://vagrantup.com/) and puppet systems, allowing you to build a drupal/apache friendly environment in next to no-time. 
That means that instead of needing to install XAMPP/WAMPP/MAMP, fight with the built in version of Apache on your Mac or configure some slow 
over-the-network VPS to run your code you can use our Vagrant / Puppy setup to run drupal in its own little virtual box.

## Tools

### Vagrant

Create and configure lightweight, reproducible, and portable development environments. A command line wrapper for VirtualBox.

### Puppet

Puppet manages your servers: describe machine configurations in an easy-to-read declarative language, and Puppet will bring your systems into the desired state and keep them there.

## Installation

Install [Vagrant](http://vagrantup.com/v1/docs/getting-started/index.html) (which requires [VirtualBox](https://www.virtualbox.org/wiki/Downloads)) then run the following commands:

	mkdir ~/vagrant
	git clone --recursive git://github.com/superstarmedia/devops-vagrant.git ~/vagrant/ssm-devops-dev
	cd ~/vagrant/ssm-devops-dev
	vagrant up

Each box has it's own local IP and its own virtual host set up, so you can set the following in your `/etc/hosts` file:

# aws-d7 dev
198.18.0.201 dev.awsd7.com

Then simply browse to `http://dev.awsd7.com`. If you would like to only bring up one server then run:

	vagrant halt # takes down all servers
	vagrant up # bring up just the one

This will hopefully give you a chance to play around with different systems other than just MySQL for a change.

## Configuring Vagrant

There is a `Vagrantfile` included in the root of this repository with some default settings enabled. Change the port number or switch to 
using a hostonly connection.

## Configuring Puppet

This repo includes a submodule which contains all of our [Puppet manifests] and various 
modules for building a LAMP stack (or something) close to that at least. 

## Configuring GUI MySQL

Connect via SSH

* name: (give a descriptive name)
* mysql host: 0.0.0.0
* username: root
* pwd: root
* datbase: none
* port: 3306
* ssh host: 127.0.0.1
* ssh user: vagrant
* ssh key: ~/.vagrant.d/insecure_private_key
* sshport: 2222

## TODO
