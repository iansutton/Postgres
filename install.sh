#!/usr/bin/env bash
MODULE_VERSION="0.1.0"

# Fail on first error
set -e

# We <3 nice output
style() {
  local label=${1:-SETUP}
  local colour="\033[34m"
  local reset="\033[0m"
  while read line; do
    echo -e "${colour}[${label}]${reset} ${line}"
  done
}

# Check user is root
if [ $(id -u) != 0 ]; then
  echo "You must run this script as root!" | style
  exit 1
fi

# Find project directory and switch to it
DIR=$( dirname "${BASH_SOURCE[0]}" )
cd ${DIR}

# Check puppet is installed
if [ ! $(command -v puppet) ]; then
  echo "No puppet installation in your path." | style
  exit 1
fi

# Check module is built
if [ ! -f ./pkg/beta-profiles-${MODULE_VERSION}.tar.gz ]; then
  echo "Could not find module package. Have you ran build.sh?" | style
  exit 1
fi

# Prevent warning messages for template directory deprecation
sed -i -e 's/^templatedir.*//' /etc/puppet/puppet.conf

# Start standalone Puppet run
puppet module install ./pkg/beta-profiles-${MODULE_VERSION}.tar.gz | style
puppet apply --hiera_config=/vagrant/files/hiera.yaml /vagrant/tests/ntp.pp | style
