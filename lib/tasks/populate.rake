namespace :db do
  desc "Erase and fill database"
  # creating a rake task within db namespace called 'populate'
  # executing 'rake db:populate' will cause this script to run
  task :populate => :environment do
    # Drop the old db and recreate from scratch
    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    # Invoke rake db:migrate
    Rake::Task['db:migrate'].invoke
    Rake::Task['db:test:prepare'].invoke
    # Need gem to make this work when adding students later: faker
    # Docs at: http://faker.rubyforge.org/rdoc/
    require 'faker'
    require 'factory_girl_rails'

    # Step 1: Create 120 customers and their associated users
    120.times do
      first_name = Faker::Name.first_name
      last_name = Faker::Name.last_name
      FactoryGirl.create(:customer, first_name: first_name, last_name: last_name)
    end

    all_customers = Customer.all

    # Step 2: for each customer associate some addresses
    all_customers.each do |customer|
      billing = FactoryGirl.create(:address, customer: customer, 
        recipient: "#{customer.proper_name}",
        street_1: "#{Faker::Address.street_address}",
        city: "#{Faker::Address.city}",
        state: "#{Address::STATES_LIST.to_h.values.sample}",
        zip: "#{rand(100000).to_s.rjust(5,"0")}",
        is_billing: true)

      if rand(3).zero?
        address_2 = FactoryGirl.create(:address, customer: customer,
          recipient: "James T. Kirk", 
          street_1: "#{Faker::Address.street_address}",
          city: "#{Faker::Address.city}",
          state: "#{Address::STATES_LIST.to_h.values.sample}",
          zip: "#{rand(100000).to_s.rjust(5,"0")}")          
      end

      if rand(4).zero?
        address_3 = FactoryGirl.create(:address, customer: customer, 
          recipient: "Jean Luc Picard",
          street_1: "#{Faker::Address.street_address}",
          street_2: "#{Faker::Address.secondary_address}",
          city: "#{Faker::Address.city}",
          state: "#{Address::STATES_LIST.to_h.values.sample}",
          zip: "#{rand(100000).to_s.rjust(5,"0")}")          
      end
    end

    # Step 3: Create some orders for each customer
    all_customers.each do |customer|
      c_address_ids = customer.addresses.map(&:id)
      order = Order.new
      order.customer_id = customer.id
      order.address_id = c_address_ids.sample
      order.date = (5.months.ago.to_date..2.days.ago.to_date).to_a.sample
      order.grand_total = (10..20).to_a.sample
      order.pay
      order.save!
      total = 0
    end
  end
end