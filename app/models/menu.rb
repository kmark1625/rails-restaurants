class Menu
  attr_accessor :target_price, :item_array
  # Takes in the target price (float) and a hash with the items and the respective price
  def initialize(target_price, item_array)
    @target_price = target_price
    @item_array = item_array
  end

  # Finds combination of items that match the target price exactly or returns nil.
  # Returned in the form of a hash {"item name" => quantity}
  def find_combination
    target_price_in_cents = (target_price * 100).to_i
    # format for each state: [item, previous state #, min_items]
    states = [0] # for the first state we will need to push 0

    (target_price_in_cents).times do
      states.push([-1]) # value to represent no current solution found for given state
    end
    # puts "Items:"
    # p item_array
    # puts "State:"
    # p states

    states.each_with_index do |state, index|
      item_array.each do |item|
        if item.price_in_cents <= index && states[index - item.price_in_cents][-1] >= 0 && (states[index - item.price_in_cents][-1] + 1 < states[index][-1] || states[index][-1] == -1)
          states[index] = [item, index-item.price_in_cents, states[index - item.price_in_cents][-1] + 1]
        end
      end
    end
    puts "Number of items: #{states[-1][-1]}"
  end
end