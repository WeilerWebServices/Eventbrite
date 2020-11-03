begin
  require 'vagrant'
rescue LoadError
  abort 'vagrant-puppet-module-registry must be loaded in a Vagrant environment.'
end

begin
  require 'vagrant-puppet-fact-generator'
rescue LoadError
  abort 'vagrant-puppet-module-registry depends on the `vagrant-puppet-fact-generator` plugin.'
end

module VagrantPlugins
  module PuppetModuleRegistry
    class Plugin < Vagrant.plugin('2')
      name 'vagrant-puppet-module-registry'
      description <<-DESC
A Vagrant plugin to manage multiple puppet module paths.
DESC

      # define configs
      config 'puppet_module_registry' do
        require_relative 'config'
        Config
      end

      # define hooks
      action_hook 'add_module_facts' do |hook|
        require_relative 'actions/add_module_facts'
        hook.before VagrantPlugins::PuppetFactGenerator::Action::GenerateFacts, Action::AddModuleFacts
      end

    end
  end
end
