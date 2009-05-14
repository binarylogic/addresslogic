require "test/unit"
require "rubygems"
require "ruby-debug"
require File.dirname(__FILE__) + "/../lib/addresslogic"

class UKAddress
  attr_accessor :street1, :street2, :city, :zip, :country
  include Addresslogic
  apply_addresslogic :fields => [:street1, :street2, [:city, :zip], :country]
end

class AmericanAddress
  attr_accessor :street1, :street2, :city, :state, :zip, :country
  include Addresslogic
  apply_addresslogic :fields => [:street1, :street2, [:city, [:state, :zip]], :country]
end