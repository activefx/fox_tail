# frozen_string_literal: true

module FoxTail
  # View Component configurations. Useful for theming.
  module Configurable
    extend ActiveSupport::Concern

    def options
      @options ||= self.class.default_options
    end

    def extract_options!(options = {})
      options.extract!(*registered_options.keys).each do |k, v|
        self.options[k.to_sym] = v
      end
    end

    included do
      class_attribute :registered_options, instance_writer: false, instance_predicate: false
      class_attribute :reserved_options, instance_accessor: false, instance_predicate: false, default: []

      self.registered_options = {}
    end

    class_methods do
      def default_options
        registered_options.reject { |_,v| v[:default].blank? }.transform_values { |v| v[:default] }
      end

      def has_option(name, as: name, default: nil, type: nil)
        raise FoxTail::ReservedOption.new(self, as) if reserved_options.include?(as.to_s)

        self.registered_options = registered_options.merge name => { name: name, as: as, default: default, type: type }

        define_method as do
          options[name]
        end

        define_method :"#{as}?" do
          if type == :boolean
            !!send(as)
          else
            send(as).present?
          end
        end
      end

      def extract_options(options = {})
        options.slice(*registered_options.keys)
      end
    end
  end
end
