class State
  attr_accessor :item, :prev_state_index, :min_items, :quantities_hash

  def initialize(item=nil, prev_state_index=nil, min_items=-1, quantities_hash=nil)
    @item = item
    @prev_state_index = prev_state_index
    @min_items = min_items
    @quantities_hash = quantities_hash
  end

  def self.initial_state
    out_of_bounds = -999
    new(nil,out_of_bounds, 0)
  end
end