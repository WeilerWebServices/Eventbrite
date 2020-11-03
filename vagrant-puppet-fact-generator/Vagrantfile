#!/usr/bin/env ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  config.vm.box = 'precise64'
  config.vm.box_url = 'http://files.vagrantup.com/precise64.box'

  config.puppet_fact_generator.add_fact('some_fact', 'some_value')

  config.vm.provision 'shell' do |s|
    s.inline = 'sudo /opt/vagrant_ruby/bin/gem install puppet --no-ri --no-rdoc --version=3.5.1'
  end

  config.vm.provision 'puppet' do |puppet|
    puppet.manifests_path = 'manifests'
    puppet.manifest_file = 'init.pp'
  end

end
