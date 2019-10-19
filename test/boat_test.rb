require './lib/boat'
require 'minitest/pride'
require 'minitest/autorun'

class BoatTest < Minitest::Test
  def setup
    @kayak = Boat.new(:kayak, 20)
  end

  def test_it_exists
    assert_instance_of Boat, @kayak
  end

  def test_it_has_attributes
    assert_equal :kayak, @kayak.type
    assert_equal 20, @kayak.price_per_hour
  end

  def test_it_starts_with_zero_hours_rented
    assert_equal 0, @kayak.hours_rented
  end

  def test_you_can_add_hours
    @kayak.add_hour
    assert_equal 1, @kayak.hours_rented
    @kayak.add_hour
    assert_equal 2, @kayak.hours_rented
    @kayak.add_hour
    assert_equal 3, @kayak.hours_rented
  end
end
