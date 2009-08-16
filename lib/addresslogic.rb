# Provides common methods and tools for using addresses
module Addresslogic
  def self.included(base)
    base.extend ClassMethods
  end
  
  module ClassMethods
    attr_accessor :address_parts_fields
    
    # Mixes in useful methods for handling addresses.
    #
    # === Options
    #
    # * <tt>fields:</tt> array of fields (default: [:street1, :street2, [:city, [:state, :zip]], :country])
    # * <tt>composition_namespace:</tt> prefixes fields names with this, great for use with composed_of in ActiveRecord.
    def apply_addresslogic(options = {})
      n = options[:composition_namespace]
      self.address_parts_fields = options[:fields] || [
        "#{n}street1".to_sym,
        "#{n}street2".to_sym,
        ["#{n}city".to_sym, ["#{n}state".to_sym, "#{n}zip".to_sym]],
        "#{n}country".to_sym
      ]
      include Addresslogic::InstanceMethods
    end
  end
  
  module InstanceMethods
    # Returns the parts of an address in an array. Example:
    #
    #   ["Street1", "Street2", "City", "State Zip", "Country"]
    #
    # This makes displaying addresses on your view pretty simple:
    #
    #   address.address_parts.join("<br />")
    #
    # === Options
    #
    # * <tt>only:</tt> fields you want included in the result
    # * <tt>except:</tt> any fields you want excluded from the result
    def address_parts(*args)
      options = args.last.is_a?(Hash) ? args.pop : {}
      options[:only] = [options[:only]] if options[:only] && !options[:only].is_a?(Array)
      options[:except] = [options[:except]] if options[:except] && !options[:except].is_a?(Array)
      fields = args[0] || self.class.address_parts_fields
      level = args[1] || 0
      
      parts = []
      fields.each do |field|
        if field.is_a?(Array)
          has_sub_array = field.find { |item| item.is_a?(Array) }
          separator = has_sub_array ? ", " : " "
          sub_parts = address_parts(field, level + 1, options).join(separator)
          next if sub_parts.empty?
          parts << sub_parts
        else
          next if !respond_to?(field)
          value = send(field)
          next if value.to_s.strip == "" || (options[:only] && !options[:only].include?(field)) || (options[:except] && options[:except].include?(field))
          parts << value
        end
      end
      
      parts
    end
  end
end

Object.send(:include, Addresslogic)