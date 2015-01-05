# Class: speedrun
#
# This is a test module for practising Puppet module development.
#
# Parameters:
#  ['user'] - Name of local user to create
#
# Sample Usage:
#  class { 'speedrun':
#    user => 'ben'
#  }
#
class speedrun (
  $user = undef
){
  file { '/etc/motd':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0660',
    content => template('speedrun/motd.erb')
  }
  if $user != undef {
    user { 'username':
      ensure => present,
      name   => $user
    }
  }
}
