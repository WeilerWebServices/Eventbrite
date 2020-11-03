module VagrantPlugins
  module PuppetFactGenerator
    class Action
      class GenerateFacts

        def initialize(app, env)
          @app = app
          @env = env
          @puppet_fact_generator = @env[:machine].config.puppet_fact_generator

          provisioner = nil
          @env[:machine].config.vm.provisioners.each do |p|
            if p.name == :puppet
              provisioner = p
              break
            end
          end
          @puppet_config = provisioner ? provisioner.config: nil
        end

        def call(env)
          if @puppet_config and @puppet_fact_generator.facts
            @puppet_fact_generator.facts.each_pair { |k, v| @env[:ui].success "Creating fact #{k} => #{v}" }
            @puppet_config.facter = @puppet_config.facter.merge(@puppet_fact_generator.facts)
          end
          @app.call(env)
        end

      end
    end
  end
end
