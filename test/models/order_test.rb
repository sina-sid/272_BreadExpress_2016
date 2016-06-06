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

    should "have a properly formatted payment receipt" do
      @melanie_o2.pay
      @melanie_o2.reload
      assert_equal "order: #{@melanie_o2.id}; amount_paid: #{@melanie_o2.grand_total}; received: #{@melanie_o2.date}", Base64.decode64(@melanie_o2.payment_receipt)
    end

    should "not pay for an order twice" do
      assert_nil @melanie_o2.payment_receipt
      receipt = @melanie_o2.pay
      @melanie_o2.reload
      assert_equal receipt, Base64.encode64("order: #{@melanie_o2.id}; amount_paid: #{@melanie_o2.grand_total}; received: #{@melanie_o2.date}")
      need_to_pay = @melanie_o2.pay
      deny need_to_pay
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

  end
end

