#!/usr/bin/env bash
MODULE_VERSION="0.1.0"

# Fail on first error
set -e

# We <3 nice output
style() {
  local label=${1:-INSTALL}
  local colour="\033[34m"
  local reset="\033[0m"
  while read line; do
    echo -e "${colour}[${label}]${reset} ${line}"
  done
}

if [ $(id -u) = 0 ]; then
  echo "This script should not be ran as root." | style
  echo "Please run again as a standard user."   | style
  exit 1
fi


# Check for Bundler in path
if [ ! $(command -v bundler) ]; then
  echo "No bundler installation in your path."    | style
  echo "Run 'gem install bundler' to install it." | style
  exit 1
fi

# Find project directory and switch to it
DIR=$( dirname "${BASH_SOURCE[0]}" )
cd $DIR

# Load Gemfile
echo 'Installing Ruby dependencies...'           | style
bundle install --deployment \
               --without development,puppet \
               --path /tmp | style

# Install gems
#bundle install | style

if [ -f pkg/profiles-${MODULE_VERSION}.tar.gz ]; then
  echo "Cleaning old module build" | style
  bundle exec rake clean           #| style
fi

# Build, install, apply
echo "Building module version ${MODULE_VERSION}" | style
bundle exec rake build #| style
