require "rails_helper"

RSpec.describe Menu, :type => :model do
  before(:each) do
    item1 = Item.new(name: "mixed fruit", price: 2.15)
    item2 = Item.new(name: "french fries", price: 2.75)
    item3 = Item.new(name: "side salad", price: 3.35)
    item4 = Item.new(name: "hot wings", price: 3.55)
    item5 = Item.new(name: "mozzarella sticks", price: 4.20)
    item6 = Item.new(name: "sampler plate", price: 5.80)
    item_array = [item1, item2, item3, item4, item5, item6]
    @menu = Menu.new(15.05, item_array)
  end

  it 'allows you to create an item' do
    expect(@menu.item_array.length).to eq(6)
  end
  it 'allows you to view the target price of a menu' do
    expect(@menu.target_price).to eq(15.05)
  end
  it 'returns combination of items with least number' do
    order = @menu.find_combination
    expect(order.keys.length).to eq(3)
  end
  it 'returns combination of items that are most diverse' do
    order = @menu.find_combination_most_diverse
    expect(order.keys.length).to eq(3)
  end
end