require File.dirname(__FILE__) + '/test_helper.rb'

class TestAddresslogix < Test::Unit::TestCase
  def test_address_parts
    assert_equal ["12 Fancy House", "Bond Street", "London W1 8AJ", "United Kingdom"], address.address_parts
    
    address.street2 = ""
    assert_equal ["12 Fancy House", "London W1 8AJ", "United Kingdom"], address.address_parts
    
    address.country = ""
    assert_equal ["12 Fancy House", "London W1 8AJ"], address.address_parts
    
    address.city = ""
    assert_equal ["12 Fancy House", "W1 8AJ"], address.address_parts
    
    address.street1 = ""
    assert_equal ["W1 8AJ"], address.address_parts
    
    address.zip = ""
    assert_equal [], address.address_parts
  end
  
  def test_options
    assert_equal ["Bond Street"], address.address_parts(:only => :street2)
    assert_equal ["12 Fancy House", "Bond Street"], address.address_parts(:only => [:street1, :street2])
    assert_equal ["12 Fancy House", "London W1 8AJ", "United Kingdom"], address.address_parts(:except => :street2)
    assert_equal ["London W1 8AJ", "United Kingdom"], address.address_parts(:except => [:street1, :street2])
  end
  
  private
    def address
      return @address if @address
      @address = Address.new
      @address.street1 = "12 Fancy House"
      @address.street2 = "Bond Street"
      @address.city = "London"
      @address.zip = "W1 8AJ"
      @address.country = "United Kingdom"
      @address
    end
end