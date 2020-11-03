module VagrantPlugins
  module PuppetModuleRegistry
    class Action
      class AddModuleFacts
        def initialize(app, env)
          @app = app
          @env = env
          @puppet_fact_generator = @env[:machine].config.puppet_fact_generator
          @puppet_module_registry = @env[:machine].config.puppet_module_registry

          provisioner = nil
          @env[:machine].config.vm.provisioners.each do |p|
            if p.name == :puppet
              provisioner = p
              break
            end
          end
          @puppet_config = provisioner ? provisioner.config: nil
        end

        # During puppet provision vagrant links all the paths provided to
        # `puppet.module_path` to temporary shared paths within the vm. It does
        # this by looping through `puppet.module_path` and linking to
        # /tmp/vagrant-puppet/modules-N, N being the index of the path within
        # the module_path array. Modules need to reference this temporary
        # directory in order to install certain files. Instead of guessing at
        # which temporary directory it will be installed in, we generate custom
        # facts that can be referenced within the module's manifests.
        #
        #   These custom facts will be of the form: "#{name}_vagrant_module_path"
        def call(env)
          if @puppet_config
            module_paths = @puppet_module_registry.get_puppet_module_paths()
            module_map = @puppet_module_registry.get_puppet_module_path_map()
            module_paths.each_with_index do |path, i|
              name = module_map.fetch(path)
              if not name
                env[:ui].warn "Failed to install custom fact for #{path}. No reference in @puppet_module_registry.puppet_module_path_to_name."
              else
                @puppet_fact_generator.add_fact(
                  "#{name}_vagrant_module_path",
                  File.join(@puppet_config.temp_dir, "modules-#{i}")
                )
              end
            end
          end
          @app.call(env)
        end

      end
    end
  end
end
