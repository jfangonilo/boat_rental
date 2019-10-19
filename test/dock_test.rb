require './lib/boat'
require './lib/renter'
require './lib/dock'
require 'minitest/pride'
require 'minitest/autorun'

class DockTest < Minitest::Test
  def setup
    @dock = Dock.new("The Rowing Dock", 3)

    @kayak_1 = Boat.new(:kayak, 20)
    @kayak_2 = Boat.new(:kayak, 20)
    @sup_1 = Boat.new(:standup_paddle_board, 15)
    @sup_2 = Boat.new(:standup_paddle_board, 15)
    @canoe = Boat.new(:canoe, 25)

    @patrick = Renter.new("Patrick Star", "4242424242424242")
    @eugene = Renter.new("Eugene Crabs", "1313131313131313")
  end

  def test_it_exists
    assert_instance_of Dock, @dock
  end

  def test_it_has_attributes
    assert_equal "The Rowing Dock", @dock.name
    assert_equal 3, @dock.max_rental_time
  end

  def test_it_starts_with_empty_log
    expected = {}
    assert_equal expected, @dock.rental_log
  end

  def test_it_can_rent
    @dock.rent(@kayak_1, @patrick)
    expected = {@kayak_1 => @patrick}
    assert_equal expected, @dock.rental_log

    @dock.rent(@kayak_2, @patrick)
    @dock.rent(@sup_1, @eugene)
    expected = {@kayak_1 => @patrick,
                @kayak_2 => @patrick,
                @sup_1 => @eugene }
    assert_equal expected, @dock.rental_log
  end

  def test_it_can_charge
    @dock.rent(@kayak_1, @patrick)
    @dock.rent(@kayak_2, @patrick)
    @dock.rent(@sup_1, @eugene)
    @kayak_1.add_hour
    @kayak_1.add_hour
    expected = {:card_number => "4242424242424242",
                :amount => 40}
    assert_equal expected, @dock.charge(@kayak_1)
  end

  def test_it_can_only_charge_to_max_time
    @dock.rent(@sup_1, @eugene)
    @sup_1.add_hour
    @sup_1.add_hour
    @sup_1.add_hour
    expected = {:card_number => "1313131313131313",
                :amount => 45}
    assert_equal expected, @dock.charge(@sup_1)

    @sup_1.add_hour
    @sup_1.add_hour
    assert_equal expected, @dock.charge(@sup_1)
  end

  def test_it_can_log_hours
    @dock.rent(@kayak_1, @patrick)
    @dock.rent(@kayak_2, @patrick)
    @dock.log_hour
    assert_equal 1, @kayak_1.hours_rented
    assert_equal 1, @kayak_2.hours_rented

    @dock.rent(@canoe, @patrick)
    @dock.log_hour
    assert_equal 1, @canoe.hours_rented
    assert_equal 2, @kayak_1.hours_rented
    assert_equal 2, @kayak_2.hours_rented
  end

  def test_revenue_starts_zero
    assert_equal 0, @dock.revenue
  end

  def test_returning_boats_generates_revenue
    @dock.rent(@kayak_1, @patrick)
    @dock.rent(@kayak_2, @patrick)
    @dock.log_hour
    @dock.rent(@canoe, @patrick)
    @dock.log_hour
    @dock.return(@kayak_1)

    expected = {@kayak_2 => @patrick,
                @canoe => @patrick}
    assert_equal 40, @dock.revenue
    assert_equal expected, @dock.rental_log

    @dock.return(@kayak_2)
    expected = {@canoe => @patrick}
    assert_equal 80, @dock.revenue
    assert_equal expected, @dock.rental_log

    @dock.return(@canoe)
    assert_equal 105, @dock.revenue
    expected = {}
    assert_equal expected, @dock.rental_log
  end

  def test_cant_charge_more_than_max_time
    @dock.rent(@sup_1, @eugene)
    @dock.rent(@sup_2, @eugene)
    @dock.log_hour
    @dock.log_hour
    @dock.log_hour
    @dock.log_hour
    @dock.log_hour
    @dock.return(@sup_1)
    @dock.return(@sup_2)
    assert_equal 90, @dock.revenue
  end

  def test_total_revenue
    @dock.rent(@kayak_1, @patrick)
    @dock.rent(@kayak_2, @patrick)
    @dock.log_hour
    @dock.rent(@canoe, @patrick)
    @dock.log_hour
    @dock.return(@kayak_1)
    @dock.return(@kayak_2)
    @dock.return(@canoe)
    @dock.rent(@sup_1, @eugene)
    @dock.rent(@sup_2, @eugene)
    @dock.log_hour
    @dock.log_hour
    @dock.log_hour
    @dock.log_hour
    @dock.log_hour
    @dock.return(@sup_1)
    @dock.return(@sup_2)
    assert_equal 195, @dock.revenue
  end
end
