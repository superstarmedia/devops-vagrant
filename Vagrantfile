# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|

  # Operating System

  ## Ubuntu 12.04 LTS (32-bit)
  # config.vm.box = "precise32"
  # config.vm.box_url = "http://files.vagrantup.com/precise32.box"

  ## Ubuntu 12.04 LTS (64-bit)
  # config.vm.box = "precise64"
  # config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  ## Ubuntu 12.10 LTS (64-bit)
  config.vm.box = "quantal64"
  config.vm.box_url = "https://github.com/downloads/roderik/VagrantQuantal64Box/quantal64.box"

  # Boot with a GUI so you can see the screen. (Default is headless)
  # config.vm.boot_mode = :gui

  # Set the default project share to use nfs
  config.vm.share_folder("v-web", "/vagrant/www", "./www", :nfs => true)
  config.vm.share_folder("v-db", "/vagrant/db", "./db", :nfs => true)

  # Set the Timezone to something useful
  config.vm.provision :shell, :inline => "echo \"America/Los_Angeles\" | sudo tee /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata"

  # Update the server
  # config.vm.provision :shell, :inline => "apt-get update --fix-missing"

  ###
  #  Creates a basic LAMP stack with MySQL
  #
  #  To launch run: vagrant up mysql
  ###
  config.vm.define :mysql do |mysql_config|
    # Map dev.pyrocms.mysql to this IP
    config.vm.network :hostonly, "198.18.0.201"

    # Enable Puppet
    mysql_config.vm.provision :puppet do |puppet|
      puppet.facter = {
        "fqdn" => "local.ssmdev.com",
        "hostname" => "www",
        "docroot" => '/vagrant/www/'
      }
      puppet.manifest_file  = "ubuntu-apache2-mysql-php5.pp"
      puppet.manifests_path = "puppet/manifests"
      puppet.module_path  = "puppet/modules"
    end
  end
end