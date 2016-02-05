class State
  attr_accessor :item, :prev_state_index, :min_items, :quantities_hash

  def initialize(item, prev_state_index, min_items, quantities_hash=nil)
    @item = item
    @prev_state_index = prev_state_index
    @min_items = min_items
    @quantities_hash = quantities_hash
  end
end