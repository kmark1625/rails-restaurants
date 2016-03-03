class Finder
  attr_accessor :menu

  def initialize(menu)
    @menu = menu
  end

  def find_combination
    states = [State.initial_state]
    (menu.target_price_in_cents).times { states.push(State.new) }

    states.each_with_index do |state, index|
      menu.item_array.each do |item|
        min_items_curr = states[index].min_items
        min_items_prev = states[index - item.price_in_cents].min_items
        prev_state_index = index-item.price_in_cents

        if curr_better_than_prev?(item, index, min_items_prev, min_items_curr)
          state.item = item
          state.prev_state_index = prev_state_index
          state.min_items = min_items_prev + 1
        end
      end
    end
    item_array = get_list_of_items(states)
    menu.number_of_items = item_array.length
    return get_quantities(item_array)
  end

  def find_combination_most_diverse
    # Each State: [item, previous state #, min_items]
    states = [State.new(nil, -999, 0, {})]
    (menu.target_price_in_cents).times { states.push(State.new) }

    states.each_with_index do |state, index|
      menu.item_array.each do |item|
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

          state.item = item
          state.prev_state_index = prev_state_index
          state.min_items = 0
          state.quantities_hash = quantities_hash_curr
        end
      end
    end
    quantities_hash = states[menu.target_price_in_cents].quantities_hash
    menu.number_of_items = total_num_items(quantities_hash)
    return quantities_hash
  end

  private
  def curr_better_than_prev?(item, index, min_items_prev, min_items_curr)
    item_less_than_price?(item, index) && min_items_prev >= 0 && (min_items_prev + 1 < min_items_curr || min_items_curr == -1)
  end

  def get_list_of_items(states_array)
    item_array = []
    num_items_combination = states_array[menu.target_price_in_cents].min_items
    return item_array if num_items_combination == -1

    items_remain = true
    val = menu.target_price_in_cents
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
    return sum if !quantities_hash
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