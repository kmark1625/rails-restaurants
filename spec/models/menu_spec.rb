require "rails_helper"

RSpec.describe Menu, :type => :model do
  it 'allows you to create a menu with an item' do
    item = build(:item, name: "mixed fruit", price: 2.15)
    item_array = [item]
    menu = build(:menu, item_array: item_array)
    expect(menu.item_array.length).to eq(1)
  end

  it 'allows you to view the target price of a menu' do
    menu = build(:menu, target_price: 15.05)
    expect(menu.target_price).to eq(15.05)
  end

  it 'returns combination of items with least number' do
    menu = build_original_menu_with_items
    order = menu.find_combination
    expect(order.keys.length).to eq(3)
  end

  it 'returns combination of items that are most diverse' do
    menu = build_original_menu_with_items
    order = menu.find_combination_most_diverse
    expect(order.keys.length).to eq(3)
  end

  it 'validates target_price is present' do
    menu = build(:menu, target_price: nil)
    expect(menu.valid?).to be(false)
  end

  it 'validates item_array is present' do
    menu = build(:menu, item_array: nil)
    expect(menu.valid?).to be(false)
  end

  it 'allows you to create a CSV' do
    menu = build_original_menu_with_items
    csv = menu.to_csv
    expect(csv).to_not be_nil
  end

  it 'returns target price in cents' do
    menu = build(:menu, target_price: 15.05)
    expect(menu.target_price_in_cents).to eq(1505)
  end

  def build_original_menu_with_items
    item1 = build(:item, name: "mixed fruit", price: 2.15)
    item2 = build(:item, name: "french fries", price: 2.75)
    item3 = build(:item, name: "side salad", price: 3.35)
    item4 = build(:item, name: "hot wings", price: 3.55)
    item5 = build(:item, name: "mozzarella sticks", price: 4.20)
    item6 = build(:item, name: "sampler plate", price: 5.80)
    item_array = [item1, item2, item3, item4, item5, item6]
    menu = build(:menu, target_price: 15.05, item_array: item_array)
  end
end