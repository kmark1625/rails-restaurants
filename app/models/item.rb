class Item
  attr_accessor :name, :price

  def initialize(name, price)
    @name = name
    @price = price
  end

  def price_in_cents
    return (price * 100).to_i
  end
end