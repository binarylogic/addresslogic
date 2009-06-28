require File.dirname(__FILE__) + '/test_helper.rb'

class TestAddresslogic < Test::Unit::TestCase
  def test_uk_uk_address_parts
    assert_equal ["12 Fancy House", "Bond Street", "London W1 8AJ", "United Kingdom"], uk_address.address_parts
    
    uk_address.street2 = ""
    assert_equal ["12 Fancy House", "London W1 8AJ", "United Kingdom"], uk_address.address_parts
    
    uk_address.country = ""
    assert_equal ["12 Fancy House", "London W1 8AJ"], uk_address.address_parts
    
    uk_address.city = ""
    assert_equal ["12 Fancy House", "W1 8AJ"], uk_address.address_parts
    
    uk_address.street1 = ""
    assert_equal ["W1 8AJ"], uk_address.address_parts
    
    uk_address.zip = ""
    assert_equal [], uk_address.address_parts
  end
  
  def test_american_address_parts
    assert_equal ["12 Fancy House", "Bond Street", "Tampa, Florida 45334", "United States"], american_address.address_parts
    
    american_address.street2 = ""
    assert_equal ["12 Fancy House", "Tampa, Florida 45334", "United States"], american_address.address_parts
    
    american_address.country = ""
    assert_equal ["12 Fancy House", "Tampa, Florida 45334"], american_address.address_parts
    
    american_address.city = ""
    assert_equal ["12 Fancy House", "Florida 45334"], american_address.address_parts
    
    american_address.state = ""
    assert_equal ["12 Fancy House", "45334"], american_address.address_parts

    american_address.street1 = ""
    assert_equal ["45334"], american_address.address_parts
    
    american_address.zip = ""
    assert_equal [], american_address.address_parts
  end
  
  def test_options
    assert_equal ["Bond Street"], uk_address.address_parts(:only => :street2)
    assert_equal ["12 Fancy House", "Bond Street"], uk_address.address_parts(:only => [:street1, :street2])
    assert_equal ["12 Fancy House", "London W1 8AJ", "United Kingdom"], uk_address.address_parts(:except => :street2)
    assert_equal ["London W1 8AJ", "United Kingdom"], uk_address.address_parts(:except => [:street1, :street2])
  end
  
  private
    def uk_address
      return @uk_address if @uk_address
      @uk_address = UKAddress.new
      @uk_address.street1 = "12 Fancy House"
      @uk_address.street2 = "Bond Street"
      @uk_address.city = "London"
      @uk_address.zip = "W1 8AJ"
      @uk_address.country = "United Kingdom"
      @uk_address
    end
    
    def american_address
      return @american_address if @american_address
      @american_address = AmericanAddress.new
      @american_address.street1 = "12 Fancy House"
      @american_address.street2 = "Bond Street"
      @american_address.city = "Tampa"
      @american_address.zip = "45334"
      @american_address.state = "Florida"
      @american_address.country = "United States"
      @american_address
    end
end