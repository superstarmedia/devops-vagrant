###########################
# SSM Puppet Config (via PyroCMS)
###########################
# OS          : Linux     #
# Database    : MySQL 5   #
# Web Server  : Apache 2  #
# PHP version : 5.3       #
###########################

include apache
include php
include mysql


# Apache setup
class {'apache::mod::php': }

apache::vhost { $fqdn :
	priority => '20',
	port => '80',
	docroot => $docroot,
	configure_firewall => false,
}

a2mod { 'rewrite': ensure => present; }

# PHP Extensions
php::module { ['xdebug', 'mysql', 'curl', 'gd'] :
    notify => [ Service['httpd'], ],
}

php::conf { [ 'mysqli', 'pdo', 'pdo_mysql', ]:
    require => Package['php-mysql'],
    notify  => Service['httpd'],
}
php::conf{['version'] :
    ensure => '5.3.5',
    notify => Service['httpd'],
}

# MySQL Server
class { 'mysql::server':
  config_hash => { 'root_password' => 'root' }
}

Database {
  require => Class['mysql::server'],
}

# Other Packages
$extras = ['vim', 'curl', 'phpunit', 'virtualbox-guest-additions', 'dnsmasq', 'drush']
package { $extras : ensure => 'installed' }

# PyroCMS Setup

file { $docroot:
    ensure  => 'directory',
}

# file { "${docroot}system/cms/config/config.php":
#     ensure  => "present",
#     mode    => "0666",
#     require => File[$docroot],
# }

$awsdir = 'aws-d7/public_html/'

$writeable_dirs = ["${docroot}aws-d7/",]

file { $writeable_dirs:
    ensure => "directory",
    mode   => '0755',
    require => File[$docroot],
}

# Blowing shit up down here

file { '/home/vagrant/testfile':
    ensure => file,
    # path => '/home/vagrant',
    mode => 0644,
    content => "host name: ${hostname} \na this is OS: ${operatingsystem} \na this is fqdn: ${fqdn} \na this is domain name: ${domain}"
}

$client_names =[
    "aws_d7",
    "dev.awsd7.com", 
    "clientone",
    "clienttwo",
    "clientthree",
]

define ssmsites{

    apache::vhost { "${title}":
        priority => '20',
        port => '80',
        docroot => "${docroot}${awsdir}",
        configure_firewall => false,
    }

    host{ "${title}":
        ip => '127.0.0.1',
    }

    database { "ssm_${title}":
        ensure  => 'present',
        charset => 'utf8',
    }

}

ssmsites { $client_names: }