###########################
# PyroCMS Puppet Config   #
###########################
# OS          : Linux     #
# Database    : SQLite 3  #
# Web Server  : Apache 2  #
# PHP version : 5.3       #
###########################

include apache
include php
include sqlite

$db_location = "/vagrant/db/pyrocms.sqlite"

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
package { 'php5-sqlite' : ensure => 'installed' }

php::module { ['xdebug', 'curl', 'gd'] : 
    notify => [ Service['httpd'], ],
}
php::conf { [ 'pdo', 'pdo_sqlite']:
    require => Package['sqlite'],
    notify  => Service['httpd'],
}

# SQLite

define sqlite::db(
    $location   = '',
    $owner      = 'root',
    $group      = 0,
    $mode       = '755',
    $ensure     = present,
    $sqlite_cmd = 'sqlite3'
  ) {

  file { $safe_location:
    ensure => $ensure,
    owner  => $owner,
    group  => $group,
    notify => Exec["create_pyrocms_db"],
  }

  exec { "create_pyrocms_db":
    command     => "${sqlite_cmd} $db_location",
    path        => '/usr/bin:/usr/local/bin',
    refreshonly => true,
  }
}


# Other Packages
$extras = ['vim', 'curl', 'phpunit']
package { $extras : ensure => 'installed' }

# PyroCMS Setup

file { $docroot:
    ensure  => 'directory',
}

file { "${docroot}system/cms/config/config.php":
    ensure  => "present",
    mode    => "0666",
    require => File[$docroot],
}

$writeable_dirs = ["${docroot}system/cms/cache/", "${docroot}system/cms/config/", "${docroot}addons/", "${docroot}assets/cache/", "${docroot}uploads/"]

file { $writeable_dirs:
    ensure => "directory",
    mode   => '0777',
    require => File[$docroot],
}