require "rails_helper"

RSpec.describe Item, :type => :model do
  it 'allows you to create an item' do
    item = Item.new("pie", 5.03)
    expect(item).to_not be_nil
  end

  it 'allows you to find the price of an item in cents' do
    item = Item.new("pie", 5.03)
    expect(item.price_in_cents).to eq(503)
  end
end