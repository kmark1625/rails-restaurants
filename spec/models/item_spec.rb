require "rails_helper"

RSpec.describe Item, :type => :model do
  before(:each) do
    @item = FactoryGirl::build(:item)
  end

  it 'allows you to create an item' do
    expect(@item).to_not be_nil
  end

  it 'allows you to find the price of an item in cents' do
    expect(@item.price_in_cents).to eq(503)
  end

  it 'allows you to find the name of an item' do
    expect(@item.name).to eq("pie")
  end

  it 'allows you to find the quantity of an item' do
    expect(@item.quantity).to eq(1)
  end
end