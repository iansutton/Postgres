# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "landregistry/ubuntu"
  config.vm.provision :shell,
    inline: 'bash /vagrant/install.sh'
end
