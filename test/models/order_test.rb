require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  require 'base64'

  # test relationships
  should belong_to(:customer)
  should belong_to(:address)

  # test simple validations with matchers
  should validate_numericality_of(:grand_total).is_greater_than_or_equal_to(0)
  should allow_value(Date.today).for(:date)
  should allow_value(1.day.ago.to_date).for(:date)
  should allow_value(1.day.from_now.to_date).for(:date)
  should_not allow_value("bad").for(:date)
  should_not allow_value(2).for(:date)
  should_not allow_value(3.14159).for(:date)
 
   context "Within context" do
    setup do 
      create_customers
      create_addresses
      create_orders
    end
    
    teardown do
      destroy_customers
      destroy_addresses
      destroy_orders
    end

    should "verify that the customer is active in the system" do
      # inactive customer
      @bad_order = FactoryGirl.build(:order, customer: @sherry, address: @alexe_a2, grand_total: 5.25, payment_receipt: "dcmjgwwtsd39x6wfc1", date: 5.days.ago.to_date)
      deny @bad_order.valid?
      # non-existent customer
      ghost = FactoryGirl.build(:customer, first_name: "Ghost")
      non_customer_order = FactoryGirl.build(:order, customer: ghost, address: @alexe_a2)
      deny non_customer_order.valid?
    end 

    should "verify that the address is active in the system" do
      # inactive address
      @bad_order = FactoryGirl.build(:order, customer: @alexe, address: @alexe_a3, grand_total: 5.25, payment_receipt: "dcmjgwwtsd39x6wfc1", date: 5.days.ago.to_date)
      deny @bad_order.valid?
      # non-existent address
      ghost = FactoryGirl.build(:address, customer: @alexe, recipient: "Ghost")
      non_address_order = FactoryGirl.build(:order, customer: @alexe, address: ghost)
      deny non_address_order.valid?
    end

    should "have a pay method which generates a receipt string" do
      assert_nil @melanie_o2.payment_receipt
      @melanie_o2.pay
      @melanie_o2.reload
      assert_not_nil @melanie_o2.payment_receipt
    end

    should "have a working scope called paid" do
      assert_equal [5.25, 5.25, 5.50, 16.50], Order.paid.all.map(&:grand_total).sort
    end

    should "have a working scope called chronological" do
      assert_equal [22.50,5.50,16.50,11, 5.25, 5.50, 5.25], Order.chronological.all.map(&:grand_total)
    end

    should "have a working scope called for_customer" do
      assert_equal [5.25, 5.25, 22.50], Order.for_customer(@alexe).all.map(&:grand_total).sort
    end 

    should "have a properly formatted payment receipt" do
      @melanie_o2.pay
      @melanie_o2.reload
      assert_equal "order: #{@melanie_o2.id}; amount_paid: #{@melanie_o2.grand_total}; received: #{@melanie_o2.date}; card: VISA 9012", Base64.decode64(@melanie_o2.payment_receipt)
    end

    should "not pay for an order twice" do
      assert_nil @melanie_o2.payment_receipt
      receipt = @melanie_o2.pay
      @melanie_o2.reload
      assert_equal receipt, Base64.encode64("order: #{@melanie_o2.id}; amount_paid: #{@melanie_o2.grand_total}; received: #{@melanie_o2.date}; card: VISA 9012")
      need_to_pay = @melanie_o2.pay
      deny need_to_pay
    end

    should "have a working class method called not_shipped" do
      create_pastries
      create_muffins
      create_order_items
      assert_equal ["Alex: 5.25", "Melanie: 5.5", "Melanie: 5.5", "Ryan: 11.0"], Order.not_shipped.all.map{|o| o.customer.first_name + ": " + o.grand_total.to_s}.sort
      destroy_pastries
      destroy_muffins
      destroy_order_items
    end

    should "have accessor methods for credit card data" do
      Order.instance_methods.include? :credit_card_number
      Order.instance_methods.include? :credit_card_number=
      Order.instance_methods.include? :expiration_year
      Order.instance_methods.include? :expiration_year=
      Order.instance_methods.include? :expiration_month
      Order.instance_methods.include? :expiration_month=
    end

    should "identify different types of credit cards by their patterns" do
      # Testing with a VISA
      order1 = Order.new
      order1.credit_card_number = 4123456789012345
      order1.expiration_year = 2016
      order1.expiration_month = 12
      assert_equal order1.credit_card_type, "VISA"   
      # Testing with an AMEX
      order2 = Order.new
      order2.credit_card_number = 371234567890123
      order2.expiration_year = 2016
      order2.expiration_month = 12
      assert_equal order2.credit_card_type, "AMEX"  
      # Testing with a bad card
      order3 = Order.new
      order3.credit_card_number = 5476876
      order3.expiration_year = 2016
      order3.expiration_month = 12
      assert_equal order3.credit_card_type, "N/A" 
    end

    should "detect different types of too-short credit card numbers" do
      # Testing with a too-short VISA
      order1 = @ryan_o1
      order1.credit_card_number = 412
      order1.expiration_year = 2016
      order1.expiration_month = 12
      deny order1.valid?
    end

    should "detect different types of too-long credit card numbers" do
      # Testing with a too-long VISA
      order1 = @ryan_o1
      order1.credit_card_number = 41234567890123456381238123681273
      order1.expiration_year = 2016
      order1.expiration_month = 12
      deny order1.valid?
    end

    should "detect valid and invalid expiration dates" do
      # Testing with a valid VISA
      order1 = @ryan_o1
      order1.credit_card_number = 4123456789012345
      order1.expiration_year = 2018
      order1.expiration_month = 12
      assert order1.valid?
      # Testing with an expired VISA
      order2 = @alexe_o1
      order2.credit_card_number = 4123456789012345
      order2.expiration_year = 2016
      order2.expiration_month = 2.months.ago.to_date.month
      deny order2.valid?
      # Testing with another expired VISA
      order2 = @alexe_o1
      order2.credit_card_number = 4123456789012345
      order2.expiration_year = 2014
      order2.expiration_month = 12
      deny order2.valid?
    end

    should "have a working is_editable? method" do
      # assert @melanie_o2.is_editable?
      deny @melanie_o1.is_editable?
      deny @alexe_o1.is_editable?
    end

    should "calculate the total weight of the order" do
      assert_equal @alexe_o1.total_weight, 4.0
      assert_equal @melanie_o2.total_weight, 8.5
    end

    should "calculate shipping costs of the order" do
      assert_equal @alexe_o1.shipping_costs, 2.0
      assert_equal @melanie_o2.shipping_costs, 2.625
    end

    should "destroy orders with no shipped items" do
      assert @melanie_o2.destroy
      assert @melanie_o2_blueberry_muffins.nil?
      assert @melanie_o2_apple_pie.nil?
    end

    should "not destroy orders with a shipped item" do
      deny @melanie_o1.destroy
    end

  end
end

