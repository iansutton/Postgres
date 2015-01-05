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
  include speedrun::motd
  if $user != undef {
    user { 'username':
      ensure => present,
      name   => $user
    }
  }
}
