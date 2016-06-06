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

end