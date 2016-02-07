require "rails_helper"

RSpec.describe State, :type => :model do
  it 'allows you to create a state' do
    item = build(:item)
    state = State.new(item, 0, 0)
    expect(state).to_not be_nil
  end

  it 'allows you to view item' do
    item = build(:item, name: "pizza")
    state = State.new(item, 0, 0)
    expect(state.item.name).to eq("pizza")
  end

  it 'allows you to view the previous index' do
    item = build(:item)
    state = State.new(item, 0, 0)
    expect(state.prev_state_index).to eq(0)
  end

  it 'allows you to view min_items' do
    item = build(:item)
    state = State.new(item, 0, 0)
    expect(state.min_items).to eq(0)
  end

  it 'allows you to view quantity_hash' do
    item = build(:item, name: "pizza")
    quantity_hash = {"pizza" => item}
    state = State.new(item, 0, 0, quantity_hash)
    expect(quantity_hash.keys.length).to eq(1)
  end
end