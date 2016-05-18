FactoryGirl.define do
  factory :customer do
    first_name "Abc"
    last_name "Def"
    email "abcdef@example.com"
    phone "4124124124"
    #association :user
    active true
  end

  factory :address do
  	association :customer
  	is_billing true
  	recipient "My Mom"
  	street_1 "Carnegie Mellon University"
  	street_2 "5000 Forbes Avenue"
  	city "Pittsburgh"
  	state "PA"
  	zip "15289"
  	active true
  end

  factory :order do
  	association :customer
  	association :address
  	date 1.day.ago.to_date
  	grand_total 45.0
  	payment_receipt "test"
  end

end