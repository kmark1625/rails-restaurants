require 'csv'

class Menu
  attr_accessor :target_price, :item_array
  # Expects target price (float) and an array of items
  def initialize(target_price, item_array)
    @target_price = target_price
    @item_array = item_array
  end

  # Finds combination of items that match the target price exactly or returns an empty array
  # Returns an array of items
  def find_combination
    target_price_in_cents = (target_price * 100).to_i
    # format for each state: [item, previous state #, min_items]
    states = [0] # for the first state we will need to push 0

    # -1 represents no current solution found for given state
    (target_price_in_cents).times do
      states.push([-1])
    end
    states.each_with_index do |state, index|
      item_array.each do |item|
        if item.price_in_cents <= index && states[index - item.price_in_cents][-1] >= 0 && (states[index - item.price_in_cents][-1] + 1 < states[index][-1] || states[index][-1] == -1)
          states[index] = [item, index-item.price_in_cents, states[index - item.price_in_cents][-1] + 1]
        end
      end
    end
    item_array = get_list_of_items(states)
    return item_array
  end

  def to_csv
    attributes = %w(item price quanity totalPrice)
    items = get_quantities(find_combination).values
    CSV.generate(headers: true) do |csv|
      csv << attributes

      items.each do |item|
        values = [item.name, item.price, item.quantity, item.price*item.quantity]
        csv.add_row values
      end
    end
  end


  # takes in an array of items and gets a hash with quantity values
  def get_quantities(items_array)
    # [item1, item2, item3, item4, etc]
    quantities = {}
    items_array.each do |item|
      item_name = item.name
      if quantities.keys.include?(item_name)
        quantities[item_name].quantity +=1
      else
        quantities[item_name] = item
      end
    end
    return quantities
  end

  private
  def get_list_of_items(states_array)
    target_price_in_cents = (target_price * 100).to_i
    item_array = []
    return item_array if states_array[target_price_in_cents][-1] == -1
    continue = true
    next_val = target_price_in_cents
    while continue
      if states_array[next_val][1] == 0
        continue = false
      else
        item_array.push(states_array[next_val][0])
        next_val = states_array[next_val][1]
      end
    end
    item_array.push(states_array[next_val][0])
    return item_array
  end
end