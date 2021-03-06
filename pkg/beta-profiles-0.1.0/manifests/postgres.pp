#Class profiles::postgres
# This class will install Postgres.
#
# Parameters: #Parameters accepted by the class
#
# ['$postgres_password'] - string
# ['$user'] - string
# [$db_password'] - string
#
# Requires: #Modules required by the class
# - puppetlabs/postgresql
#
# Sample Usage:
# class { 'profiles::postgres': }
#
# Hiera:
#  profiles::postgres::postgres_password: postgres

class profiles::postgres (

  $postgres_password = undef,
  $db_name = undef,
  $db_user = undef,
  $db_password = undef,
  $postgres_root = undef,
  $postgres_data = undef

) {

# create data dir
file { $postgres_root:
  ensure => 'directory',
  owner  => 'root',
  group  => 'root',
  mode   => '0777',
}

class { 'postgresql::globals':
  manage_package_repo => true,
  version             => '9.3',
  encoding            => 'UTF8',
  # set data dir to non default
  locale              => 'en_GB.utf8',
  #datadir             => "${postgres_root}${postgres_data}",
  needs_initdb        => true,
} ->

class { 'postgresql::server':
  ip_mask_deny_postgres_user => '0.0.0.0/32',
  ip_mask_allow_all_users    => '0.0.0.0/0',
  listen_addresses           => '*',
  ipv4acls                   => ['host all all 0.0.0.0/0 trust'],
  postgres_password          => $postgres_password
}

# our database
postgresql::server::db { $db_name:
  user     => $db_user,
  password => postgresql_password($db_user, $db_password),
} ->

# Create ENV file

file { '/var/lib/postgresql/PG':
  ensure  => present,
  content => 'export PATH=$PATH:/usr/lib/postgresql/9.3/bin
              export PGDATA=/postgresql/data/',
}

# install contrib modules
class { 'postgresql::server::contrib':
package_ensure => 'present',
}

}
