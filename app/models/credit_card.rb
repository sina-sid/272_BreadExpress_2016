
# PROCESSING CREDIT CARDS WITH RUBY
#
# Credit card numbers follow a certain pattern specific to the type of credit card, and
# follow an algorithm called the Luhn formula. For the purposes of this problem, we only
# want to check credit-card specific information, and not bother with the more complicated
# Luhn formula.
#
# Credit card type-specific rules generally state that a number must start with a string
# of digits, and have a specific length. An incomplete list of the rules:
#
#	  Card CCType              Abbrev       Prefixes         Length
#	  American Express        AMEX        34 or 37          15
#	  Diners Club             DCCB        300-305           14
#	  Discover Card           DISC        6011 or 65        16
#	  Master Card             MC          51-55             16
#	  Visa                    VISA        4                 13 or 16
#
# Your mission Mr. Phelps and (your name here), should you choose to accept it (you must),
# is to create a credit card class (called 'CreditCard') that will allow us to do some basic 
# card processing.  Upon creating a new card object, the user should have to pass in the 
# card number, expiration year, and expiration month [in that order].  We are not going to 
# pass in the card type; it will be automatically detected from the card number.  The class 
# needs one method called 'valid?' which returns either true or false, depending on if the
# card number conforms to the rules above and whether the expiration date has passed.  {Note:
# you are welcome to create other methods and even other classes -- my solution does both -- 
# but we are only testing the 'valid?' method for the class 'CreditCard'}
# 
# Examples:  (...just 3 of the 30 we will test)
# 
# CreditCard.new(4123456789012, 2016, 12).valid?   # a valid VISA card
# => true
# 
# CreditCard.new(41234567890123456789, 2016, 12).valid?   # VISA with too many digits
# => false
# 
# CreditCard.new(4123456789012, 2004, 12).valid?  # a VISA card expired long, long ago
# => false
#
# Super Bonus Time: add an additional method to the class which returns the credit card's
# name (the 2-4 letter abbreviation is what we are looking for here).  If you still have time 
# in lab, this must be completed; only optional if you are struggling for time to get the 
# first part done.
#
# _____________________________________
# SOLUTION TIME:
# Need some gems first...
  require 'rubygems'
  require 'date'
  require 'time'

# Now your solution goes here...
class CCType

  attr_reader :name, :pattern

  def initialize(name, pattern)
  	@name = name
  	@pattern = pattern
  end

  def match(number)
  	@pattern.match(number.to_s)
  end
end




class CreditCard

  VALID_TYPES = [CCType.new("AMEX", /^3(4|7)\d{13}$/), 
                 CCType.new("DCCB", /^30[0-5]\d{11}$/), 
                 CCType.new("DISC", /^6(011|5\d\d)\d{12}$/), 
                 CCType.new("MC", /(^5[1-5]\d{14}$)/), 
                 CCType.new("VISA", /^4\d{12}(\d{3})?$/)]
  attr_reader :number, :type
  attr_reader :year, :month

  def initialize(number, year, month)
  	@number = number.to_s
  	@year = year
  	@month = month
    @type = VALID_TYPES.detect{|v| v.match(@number)}
  end

  def new
  	@CreditCard = CreditCard.new
  end

  def expiration
    "#{month}/#{year}"
  end

  def expired?
    today = Date.today
    year < today.year or (year == today.year and month < today.month)
  end

  def valid?
  	!expired? and !type.nil?
  end

  
end

