require File.dirname(__FILE__) + '/test_helper.rb'

class TestAddresslogix < Test::Unit::TestCase
  def test_address_parts
    assert_equal ["Street1", "Street2", "City, State 22933", "United States of America"], address.address_parts
    
    address.street2 = ""
    assert_equal ["Street1", "City, State 22933", "United States of America"], address.address_parts
    
    address.state = ""
    assert_equal ["Street1", "City, 22933", "United States of America"], address.address_parts
    
    address.country = ""
    assert_equal ["Street1", "City, 22933"], address.address_parts
    
    address.city = ""
    assert_equal ["Street1", "22933"], address.address_parts
    
    address.street1 = ""
    assert_equal ["22933"], address.address_parts
    
    address.zip = ""
    assert_equal [], address.address_parts
  end
  
  def test_options
    assert_equal ["Street2"], address.address_parts(:only => :street2)
    assert_equal ["Street1", "Street2"], address.address_parts(:only => [:street1, :street2])
    assert_equal ["Street1", "City, State 22933", "United States of America"], address.address_parts(:except => :street2)
    assert_equal ["City, State 22933", "United States of America"], address.address_parts(:except => [:street1, :street2])
  end
  
  private
    def address
      return @address if @address
      @address = Address.new
      @address.street1 = "Street1"
      @address.street2 = "Street2"
      @address.city = "City"
      @address.state = "State"
      @address.zip = "22933"
      @address.country = "United States of America"
      @address
    end
end