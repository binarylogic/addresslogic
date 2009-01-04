require "test/unit"
require "rubygems"
require "ruby-debug"
require File.dirname(__FILE__) + "/../lib/addresslogic"

class Address
  attr_accessor :street1, :street2, :city, :state, :zip, :country
  include Addresslogic
end