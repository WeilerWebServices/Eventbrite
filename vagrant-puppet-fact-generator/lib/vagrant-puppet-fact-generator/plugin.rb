begin
  require 'vagrant'
rescue LoadError
  abort 'vagrant-puppet-fact-generator must be loaded in a Vagrant environment.'
end


module VagrantPlugins
  module PuppetFactGenerator
    class Plugin < Vagrant.plugin('2')
      name 'vagrant-puppet-fact-generator'
      description <<-DESC
A Vagrant plugin that allows other plugins to generate custom facts for provisioning.
DESC

      # define configs
      config 'puppet_fact_generator' do
        require_relative 'config'
        Config
      end

      # define hooks
      action_hook 'setup_provision' do |hook|
        require_relative 'actions/generate_facts'
        hook.before Vagrant::Action::Builtin::Provision, Action::GenerateFacts
      end

    end
  end
end
