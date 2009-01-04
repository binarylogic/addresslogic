# = Address Logic
#
# This is a simple module that you can include into any classm as long as it has a street1, street2, city, state, zip, and country (optional)
# methods. Just include it into your class like so:
#
#   class Address
#     include AddressLogic
#   end
#
# This adds a sigle method: address_parts. More on this method below...
module Addresslogic
  # Returns the parts of an address in an array. Example:
  #
  #   ["Street1", "Street2", "City, State, Zip", "Country"]
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
    
    parts = {}
    [:street1, :street2, :city, :state, :zip, :country].each do |part|
      next if !respond_to?(part)
      value = send(part)
      next if value.to_s.strip == "" || (options[:only] && !options[:only].include?(part)) || (options[:except] && options[:except].include?(part))
      parts[part] = value
    end
    
    state_parts = [parts[:state], parts[:zip]].compact.join(" ")
    state_parts = nil if state_parts.strip == ""
    city_parts = [parts[:city], state_parts].compact.join(", ")
    city_parts = nil if city_parts.strip == ""
    [parts[:street1], parts[:street2], city_parts, parts[:country]].compact
  end
end