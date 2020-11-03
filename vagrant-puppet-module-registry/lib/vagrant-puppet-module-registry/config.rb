module VagrantPlugins
  module PuppetModuleRegistry
    class Config < Vagrant.plugin(2, :config)

      attr_accessor :puppet_module_paths
      attr_accessor :puppet_module_path_to_name

      def initialize
        @puppet_module_paths = UNSET_VALUE
        @puppet_module_path_to_name = UNSET_VALUE
      end

      # Return a hash which should be of the form module_path => name.
      def get_puppet_module_path_map
        if @puppet_module_path_to_name == UNSET_VALUE
          @puppet_module_path_to_name = {}
        end
        return @puppet_module_path_to_name
      end

      # Return an array of modules to be added to puppet's module path when
      # provisioning
      def get_puppet_module_paths
        if @puppet_module_paths == UNSET_VALUE
          @puppet_module_paths = []
        end
        return @puppet_module_paths
      end

      # Add a path to the `puppet_module_paths` array as well as the
      # `puppet_module_path_to_name` hash. This gives us a mechanism to loop
      # through `puppet_module_paths` and retrieve the name the path is
      # associated with.
      def register_module_path(name, path)
        module_map = get_puppet_module_path_map()
        module_paths = get_puppet_module_paths()
        module_map[path] = name
        module_paths.push(path)
      end

      def finalize!
        @puppet_module_paths = [] if @puppet_module_paths == UNSET_VALUE
        @puppet_module_path_to_name = {} if @puppet_module_path_to_name == UNSET_VALUE
      end

      def validate(machine)
        errors = []
        if @puppet_module_path_to_name and
          not @puppet_module_path_to_name.kind_of?(Hash)
          errors << "`puppet_module_path_to_name` must be a hash"
        end
        return { "puppet_module_registry" => errors }
      end

    end
  end
end
