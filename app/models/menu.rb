require 'csv'

class Menu
  include ActiveModel::Validations

  attr_accessor :target_price, :item_array, :number_of_items
  validates :target_price, :presence => true
  validates :item_array, :presence => true

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
    @number_of_items = 0
  end

  def find_combination
    finder = Finder.new(self)
    finder.find_combination
  end

  def find_combination_most_diverse
    finder = Finder.new(self)
    finder.find_combination_most_diverse
  end

  def to_csv
    attributes = %w(item price quanity totalPrice)
    items = find_combination.values
    CSV.generate(headers: true) do |csv|
      csv << attributes
      items.each do |item|
        values = [item.name, item.price, item.quantity, item.price*item.quantity]
        csv.add_row values
      end
    end
  end

  def target_price_in_cents
    (target_price * 100).to_i
  end
end