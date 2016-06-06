FactoryGirl.define do
  factory :customer do
    first_name "Ed"
    last_name "Gruberman"
    phone { rand(10 ** 10).to_s.rjust(10,'0') }
    email { |u| "#{u.first_name[0]}#{u.last_name}#{(1..99).to_a.sample}@example.com".downcase }
    active true
  end

  factory :address do
    recipient "Ted Gruberman"
    street_1 "5000 Forbes Avenue"
    street_2 nil
    city "Pittsburgh"
    state "PA"
    zip "15213"
    association :customer
    is_billing false
    active true
  end

  factory :order do
    date Date.today
    association :customer
    association :address
    grand_total 0.00
    payment_receipt nil
  end

  factory :item do
    name "Honey Wheat Bread"
    description "Best. Bread. Ever."
    category "bread"
    picture "home-1.jpg"
    units_per_item 12
    weight 1.1
    active true
  end

  factory item_prices do
    association :item
    price 8.50
    start_date Date.today
    end_date nil
  end

  factory order_items do
    association :order
    association :item
    quantity 1
    shipped_on Date.today
  end

  factory user do
    username "example"
    role "admin"
    active true
  end

end