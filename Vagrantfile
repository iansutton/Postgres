# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "landregistry/centos-beta"
#  config.vm.provision :shell,
#    inline: 'bash /vagrant/install.sh'

  # https://github.com/mitchellh/vagrant/issues/1673
  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"
end
