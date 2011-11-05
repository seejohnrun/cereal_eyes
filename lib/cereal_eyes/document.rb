require File.dirname(__FILE__) + '/attribute_error'

module CerealEyes

  module Document

    def self.included(base)
      base.extend ClassMethods
      base.send :include, InstanceMethods
    end

    module ClassMethods

      # Details of the serialized attributes on this class
      # @return Array the serialized attributes
      def serialized_attributes
        @serialized_attributes ||= []
      end

      # Define an attribute on this model
      # @param name [String] - the name of this field
      # @option options [Object] :default - A default value for this attribute if it not given
      # @option options [Boolean] :deserialize - Whether or not to deserialize this field (default: true)
      # @option options [Boolean] :serialize - Whether or not to serialize this field (default: true)
      # @option options [String|Symbol] :name - An alternate name for the serialized form of this field
      # @option options [Class] :type - A nested type for this segment
      # @option options [Boolean] :squash_nil - Whether or not to output nil values (default: true)
      def attribute(field, options = {})
        # set defaults 
        options[:deserialize] = true unless options.has_key?(:deserialize)
        options[:serialize] = true unless options.has_key?(:serialize)
        options[:squash_nil] = true unless options.has_key?(:squash_nil)
        options[:name] ||= field
        options[:name] = options[:name].to_sym unless Symbol === options[:name]
        options[:field] = field
        # make sure we're not breaking the serialization rule
        if serialized_attributes.any? { |o| o[:serialize] && options[:serialize] && o[:name] == options[:name] }
          raise CerealEyes::AttributeError.new "Unable to set duplicate attribute for serialization with name: #{options[:name]}"
        end
        if serialized_attributes.any? { |o| o[:deserialize] && options[:deserialize] && o[:field] == options[:field] }
          raise CerealEyes::AttributeError.new "Unable to set duplicate attribute for deserialization on field: #{options[:field]}"
        end
        # add to hash
        key = options[:name].is_a?(Symbol) ? options[:name] : options[:name].to_sym
        serialized_attributes << options
        # create the reader if deserializable
        attr_reader(field) if options[:deserialize]
        attr_writer(field) if options[:serialize]
        nil
      end

      # Perform the deserialization on a hash, returning the resultant object
      def deserialize(data)
        return nil if data.nil?
        obj = new
        # go through what we have and use it
        serialized_attributes.each do |options|
          next unless options[:deserialize]
          name = options[:name]
          value = data[name]
          value ||= data[name.to_s] unless String === name
          if value && options[:type] # nesting
            if value.is_a?(Array)
              value = value.map { |v| puts v.inspect; options[:type].deserialize(v) }
            else
              value = options[:type].deserialize(value)
            end
          end
          obj.instance_variable_set(:"@#{options[:field]}", value || options[:default])
        end
        obj
      end

    end

    module InstanceMethods

      # Serialize the given document
      # @return Hash representing the serialized format of the document
      def serialize
        data = {}
        self.class.serialized_attributes.each do |options|
          next unless options[:serialize]
          value = instance_variable_get(:"@#{options[:field]}") || options[:default]
          if value && options[:type]
            if value.kind_of?(CerealEyes::Document)
              value = value.serialize
            elsif value.is_a?(Array)
              value = value.map(&:serialize)
            else
              raise ArgumentError.new("Don't know how to serialize type: #{options[:type]}")
            end
          end
          value = value.serialize if value.kind_of?(CerealEyes::Document)
          data[options[:name]] = value if value || !options[:squash_nil]
        end
        data
      end

    end

  end

end
