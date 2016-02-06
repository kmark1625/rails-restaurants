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

  def find_combination_most_diverse
    # Each State: [item, previous state #, min_items]
    states = [State.new(nil, -999, 0, {})]
    # -1 represents no current solution found for given state
    (target_price_in_cents).times { states.push(State.new(nil, nil, -1)) }

    states.each_with_index do |state, index|
      item_array.each do |item|
        quantities_hash_curr = states[index].quantities_hash
        quantities_hash_prev = states[index - item.price_in_cents].quantities_hash
        prev_state_index = index-item.price_in_cents

        if item_less_than_price?(item, index) && quantities_hash_prev != nil
          # TODO: Add conditional which verifies current is more diverse
          quantities_hash_new = add_item(quantities_hash_prev.deep_dup, item)

          if quantities_hash_curr == nil
            quantities_hash_curr = quantities_hash_new
          elsif more_diverse?(quantities_hash_new, quantities_hash_curr)
             quantities_hash_curr = quantities_hash_new
          end
          # quantities_hash_curr = quantities_hash_new if more_diverse?(quantities_hash_new, quantities_hash_curr)
          # quantities_hash_curr = add_item(quantities_hash_prev.deep_dup, item)
          states[index] = State.new(item, prev_state_index, 0, quantities_hash_curr)
        end
      end
    end
    quantities_hash = states[target_price_in_cents].quantities_hash
    @number_of_items = total_num_items(quantities_hash)
    return quantities_hash
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

  def add_item(quantities_hash, item)
    if quantities_hash.keys.include?(item.name)
      quantities_hash[item.name].quantity +=1
    else
      quantities_hash[item.name] = item
    end
    return quantities_hash
  end

  def total_num_items(quantities_hash)
    sum = 0
    quantities_hash.each do |key, index|
      sum += index.quantity
    end
    return sum
  end

  def more_diverse?(quantities_hash_new, quantities_hash_curr)
    new_quantities_array = get_quantities_array(quantities_hash_new).sort
    curr_quantities_array = get_quantities_array(quantities_hash_curr).sort
    more_diverse_var = more_diverse(new_quantities_array, curr_quantities_array)

    return more_diverse_var
  end

  def get_quantities_array(quantity_hash)
    array = []
    quantity_hash.each do |name, item|
      array.push(item.quantity)
    end
    return array
  end

  def more_diverse(array1, array2)
    if array1.length < array2.length
      return false
    elsif array2.length < array1.length
      return true
    else
      return (array1 <=> array2) > 0
    end
  end
end