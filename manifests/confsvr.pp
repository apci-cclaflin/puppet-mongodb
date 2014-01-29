class mongodb::confsvr {

  include mongodb

  $mongodb_config_svr  = 'true'
  $mongodb_configdb    = 'false'
  $mongodb_dbpath      = hiera('mongodb_dbpath', '/var/lib/mongodb')
  $mongodb_listen_port = 27019
  $mongodb_replica_set = 'false'

  file { "/etc/mongodb.conf":
    owner   => root,
    group   => admin,
    mode    => 644,
    notify  => Service["mongodb"],
    content => template("mongodb/mongodb.conf.erb"),
  }

}
