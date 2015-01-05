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
if [ ! -f ./pkg/benfairless-speedrun-${MODULE_VERSION}.tar.gz ]; then
  echo "Could not find module package. Have you ran build.sh?" | style
  exit 1
fi

# Start standalone Puppet run
puppet module install ./pkg/benfairless-speedrun-${MODULE_VERSION}.tar.gz | style
puppet apply tests/master.pp | style

# Ensure that machine resolves 'puppet' to localhost
sed -i -e 's/\(127.0.0.1.*\)puppet/\1  puppet/' /etc/hosts
