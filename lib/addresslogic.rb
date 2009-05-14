require 'activerecord'

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
      self.address_parts_fields = args[:fields] || [:street1, :street2, :city, [:state, :zip], :country]
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
    def address_parts(options = {})
      options[:only] = [options[:only]] if options[:only] && !options[:only].is_a?(Array)
      options[:except] = [options[:except]] if options[:except] && !options[:except].is_a?(Array)
    
      parts = []
      address_parts_fields.each do |part|
        if part.is_a?(Array)
          # We only want to allow 2d arrays
          subparts = []
          part.flatten.each do |subpart|
            next if !respond_to?(subpart)
            value = send(subpart)
            next if value.to_s.blank? || (options[:only] && !options[:only].include?(subpart)) || (options[:except] && options[:except].include?(subpart))
            subparts << value
          end
          parts << subparts unless subparts.compact.empty?
        else
          next if !respond_to?(part)
          value = send(part)
          next if value.to_s.strip == "" || (options[:only] && !options[:only].include?(part)) || (options[:except] && options[:except].include?(part))
          parts << value
        end
      end
      
      result = parts.collect do |part|
        if part.is_a?(Array)
          part.collect{|sub| sub.to_s.strip.blank? ? nil : sub}.join(" ")
        else
          part.to_s.strip.blank? ? nil : part
        end
      end
      
      return result.compact
    end
    
    private
      def address_parts_fields
        self.class.address_parts_fields
      end
  end
end

ActiveRecord::Base.send(:include, Addresslogic)