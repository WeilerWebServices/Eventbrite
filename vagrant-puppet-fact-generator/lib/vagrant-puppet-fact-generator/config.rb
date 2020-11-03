module VagrantPlugins
  module PuppetFactGenerator
    class Config < Vagrant.plugin(2, :config)
      attr_accessor :facts

      def initialize
        @facts = UNSET_VALUE
      end

      def get_facts
        if @facts == UNSET_VALUE
          @facts = {}
        end
        return @facts
      end

      def add_fact(fact_name, value)
        facts = get_facts()
        facts[fact_name] = value
      end

      def finalize!
        @facts = {} if @facts == UNSET_VALUE
      end

      def validate(machine)
        errors = []
        if @facts and not @facts.kind_of?(Hash)
          errors << '`facts` must be a hash of form fact_name => fact_value'
        end

        return {'puppet_fact_generator' => errors}
      end

    end
  end
end
