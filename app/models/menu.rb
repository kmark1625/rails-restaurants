require 'csv'

class Menu
  attr_accessor :target_price, :item_array
  attr_reader :number_of_items

  # Expects target price (float) and an array of items
  def initialize(target_price, item_array)
    @target_price = target_price
    @item_array = item_array
    @number_of_items = 0
  end

  # Finds combination of items that match the target price exactly. Returns an array of items
  def find_combination
    # Each State: [item, previous state #, min_items]
    # states = [[nil, -999, 0]] # For the first state we set to 0
    states = [State.new(nil, -999, 0)]
    # -1 represents no current solution found for given state
    (target_price_in_cents).times { states.push(State.new(nil, nil, -1)) }

    states.each_with_index do |state, index|
      item_array.each do |item|
        min_items_curr = states[index].min_items
        min_items_prev = states[index - item.price_in_cents].min_items
        prev_state_index = index-item.price_in_cents
        if item_less_than_price?(item, index) && min_items_prev >= 0 && (min_items_prev + 1 < min_items_curr || min_items_curr == -1)
          states[index] = State.new(item, prev_state_index, min_items_prev + 1)
        end
      end
    end
    item_array = get_list_of_items(states)
    @number_of_items = item_array.length
    return get_quantities(item_array)
  end

  # def find_combination
  #   target_price_in_cents = (target_price * 100).to_i
  #   # format for each state: [item, previous state #, previous_item_array]
  #   states = [[]] # for the first state we will need to push 0
  #   # -1 represents no current solution found for given state
  #   (target_price_in_cents).times do
  #     states.push([-1])
  #   end
  #   states.each_with_index do |state, index|
  #     item_array.each do |item|
  #       if item.price_in_cents <= index && states[index - item.price_in_cents][-1].length >= 0 && (states[index - item.price_in_cents][-1] + 1 < states[index][-1] || states[index][-1] == -1)
  #         states[index] = [item, index-item.price_in_cents, states[index - item.price_in_cents][-1] + 1]
  #       end
  #     end
  #   end
  #   item_array = get_list_of_items(states)
  #   return item_array
  # end

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

  private
  def get_list_of_items(states_array)
    item_array = []
    num_items_combination = states_array[target_price_in_cents].min_items
    return item_array if num_items_combination == -1

    items_remain = true
    val = target_price_in_cents
    while items_remain
      current_state = states_array[val]
      if states_array[val].prev_state_index == -999
        items_remain = false
      else
        item_array.push(current_state.item)
        val = current_state.prev_state_index
      end
    end
    return item_array
  end

  # Takes in an array of items and returns a hash with quantity values
  def get_quantities(items_array)
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

  def target_price_in_cents
    (target_price * 100).to_i
  end

  def item_less_than_price?(item, price)
    return item.price_in_cents <= price
  end
end