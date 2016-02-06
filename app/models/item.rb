class Item
  include ActiveModel::Validations

  attr_accessor :name, :price, :quantity

  validates :name, :presence => true
  validates :price, :presence => true

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
    @quantity = 1
  end

  def price_in_cents
    return (price * 100).to_i
  end

  def persisted?
    false
  end
end