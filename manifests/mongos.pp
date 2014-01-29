# Class: mongodb::mongos
#
# This class installs MongoDB (stable)
#
# Actions:
#  - Install MongoDB using a 10gen Ubuntu repository
#  - Manage the mongos service
#
# Sample Usage:
#  include mongodb::mongos
#
class mongodb::mongos {

  $mongodb_kill_limit     = hiera('mongodb_kill_limit', 300)
  $mongodb_process_name   = 'mongos'
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
    enable  => false,
    ensure  => stopped,
    require => Package["mongodb-10gen"],
  }

  service { "mongos":
    enable  => true,
    ensure  => running,
    require => [ Package["mongodb-10gen"], File["/etc/init/mongos.conf"] ],
  }

  file { "/etc/init/mongos.conf":
    content => template("mongodb/init-mongodb.conf.erb"),
    mode    => "0644",
    notify  => Service["mongos"],
    require => Package["mongodb-10gen"],
  }

  file { "/etc/logrotate.d/mongodb":
    owner  => root,
    group  => admin,
    mode   => 644,
    source => "puppet:///modules/mongodb/logrotate-mongodb",
  }

}
