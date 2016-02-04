require "rails_helper"

RSpec.describe Menu, :type => :model do
  it 'allows you to create an item' do
    item1 = Item.new("pie", 5.03)
    item2 = Item.new("pizza", 5.05)
    item_array = [item1, item2]
    menu = Menu.new(15.05, item_array)
    expect(menu).to_not be_nil
  end
  it 'allows you to view the target price of a menu' do
    item1 = Item.new("pie", 5.03)
    item2 = Item.new("pizza", 5.05)
    item_array = [item1, item2]
    menu = Menu.new(15.05, item_array)
    expect(menu.target_price).to eq(15.05)
  end
  it 'allows you to view the item array of a menu' do
    item1 = Item.new("pie", 5.03)
    item2 = Item.new("pizza", 5.05)
    item_array = [item1, item2]
    menu = Menu.new(15.05, item_array)
    expect(menu.item_array).to_not be_nil
  end
  it 'returns combination of items with least number' do
    item1 = Item.new("mixed fruit", 2.15)
    item2 = Item.new("french fries", 2.75)
    item3 = Item.new("side salad", 3.35)
    item4 = Item.new("hot wings", 3.55)
    item5 = Item.new("mozzarella sticks", 4.20)
    item6 = Item.new("sampler plate", 5.80)
    item_array = [item1, item2, item3, item4, item5, item6]
    menu = Menu.new(15.05, item_array)
    order = menu.find_combination
    expect(order.length).to eq(4)
  end
  it 'returns order with quantity' do
    item1 = Item.new("mixed fruit", 2.15)
    item2 = Item.new("french fries", 2.75)
    item3 = Item.new("side salad", 3.35)
    item4 = Item.new("hot wings", 3.55)
    item5 = Item.new("mozzarella sticks", 4.20)
    item6 = Item.new("sampler plate", 5.80)
    item_array = [item1, item2, item3, item4, item5, item6]
    menu = Menu.new(15.05, item_array)
    order = menu.find_combination
    quantity_hash = menu.get_quantities(order)
    expect(quantity_hash.keys.length).to eq(3)
  end
end