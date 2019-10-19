class Dock
  attr_reader :name, :max_rental_time, :rental_log, :revenue

  def initialize(name, max_rental_time)
    @name = name
    @max_rental_time = max_rental_time
    @rental_log = {}
    @revenue = 0
  end

  def rent(boat, renter)
    @rental_log[boat] = renter
  end

  def charge(boat)
    time_to_charge = [boat.hours_rented, @max_rental_time].min
    charge = time_to_charge * boat.price_per_hour
    renter_number = @rental_log[boat].credit_card_number
    charge_hash = {}
    charge_hash[:card_number] = renter_number
    charge_hash[:amount] = charge
    charge_hash
  end

  def log_hour
    rental_log.each {|boat, renter| boat.add_hour}
  end

  def return(boat)
    @revenue += charge(boat)[:amount]
    @rental_log.delete(boat)
  end
end
