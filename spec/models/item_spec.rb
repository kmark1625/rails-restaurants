require "rails_helper"

RSpec.describe Item, :type => :model do
  it 'allows you to create an item' do
    item = build(:item)
    expect(item).to_not be_nil
  end

  it 'allows you to find the name of an item' do
    item = build(:item, name: "pizza")
    expect(item.name).to eq("pizza")
  end

  it 'allows you to find the price of an item in cents' do
    item = build(:item, price: 6.05)
    expect(item.price_in_cents).to eq(605)
  end

  it 'allows you to find the price of an item' do
    item = build(:item, price: 6.05)
    expect(item.price).to eq(6.05)
  end

  it 'allows you to find the quantity of an item' do
    item = build(:item)
    expect(item.quantity).to eq(1)
  end

  it 'validates name is present' do
    item = build(:item, name: nil)
    expect(item.valid?).to be(false)
  end

  it 'validates price is present' do
    item = build(:item, price: nil)
    expect(item.valid?).to be(false)
  end
end