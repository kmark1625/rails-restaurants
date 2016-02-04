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
end