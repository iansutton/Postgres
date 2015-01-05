# Class: speedrun::motd
#
# Resource for managing message of the day on *nix systems.
#
# Parameters:
#  none
#
# Sample Usage:
#  class { 'speedrun::motd': }
#
class speedrun::motd {
  file { '/etc/motd':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('speedrun/motd.erb')
  }
}
