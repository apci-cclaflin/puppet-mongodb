# Class: mongodb
#
# This class installs MongoDB (stable)
#
# Actions:
#  - Install MongoDB using a 10gen Ubuntu repository
#  - Manage the MongoDB service
#
# Sample Usage:
#  include mongodb
#
class mongodb {

  $mongodb_kill_limit     = hiera('mongodb_kill_limit', 300)
  $mongodb_ulimit_nofile  = hiera('mongodb_ulimit_nofile', 20000)
  $mongodb_version        = hiera('mongodb_version', 'latest')

  apt::source { "mongodb":
    location        => "http://downloads-distro.mongodb.org/repo/ubuntu-upstart",
    include_release => false,    
    repos           => "dist 10gen",
    include_src     => false,
    key             => "7F0CEB10",
    key_server      => "keyserver.ubuntu.com",
  }

  package { "mongodb-10gen":
    ensure  => $mongodb_version,
    require => Apt::Source["mongodb"],
  }

  service { "mongodb":
    enable => true,
    ensure => running,
    require => Package["mongodb-10gen"],
  }

  file { "/etc/init/mongodb.conf":
    content => template("mongodb/mongodb.conf.erb"),
    mode => "0644",
    notify => Service["mongodb"],
    require => Package["mongodb-10gen"],
  }

}
