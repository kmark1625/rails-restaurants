# Defines Item class
FactoryGirl.define do
  factory :item do
    name "pie"
    price 5.03
  end

  factory :menu do
    target_price 15.00
    item_array []
  end
end