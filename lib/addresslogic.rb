# = Address Logic
#
# This is a simple module that you can include into any classm as long as it has a street1, street2, city, state, zip, and country (optional)
# methods. Just include it into your class like so:
#
#   class Address
#     apply_addresslogic :fields => [:street1, :street2, :city, [:state, :zip], :country]
#   end
#
# The above will return:
#   ["Street1", "Street2", "City", "State Zip", "Country"]
#
# This adds a sigle method: address_parts. More on this method below...
module Addresslogic
  def self.included(base)
    base.extend ClassMethods
  end
  
  module ClassMethods
    attr_accessor :address_parts_fields
    
    def apply_addresslogic(args = {})
      self.address_parts_fields = args[:fields] || [:street1, :street2, [:city, [:state, :zip]], :country]
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
      fields = args[0] || address_parts_fields
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
    
    private
      def address_parts_fields
        self.class.address_parts_fields
      end
  end
end

Object.send(:include, Addresslogic)