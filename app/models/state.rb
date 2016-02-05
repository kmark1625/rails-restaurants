class State
  attr_accessor :item, :prev_state_index, :min_items

  def initialize(item, prev_state_index, min_items)
    @item = item
    @prev_state_index = prev_state_index
    @min_items = min_items
  end
end