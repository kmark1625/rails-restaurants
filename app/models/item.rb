class Item
  attr_accessor :name, :price, :quantity

  def initialize(name, price)
    @name = name
    @price = price
    @quantity = 1
  end

  def price_in_cents
    return (price * 100).to_i
  end
end