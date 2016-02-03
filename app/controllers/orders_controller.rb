class OrdersController < ApplicationController
  def index
    @inputfile = Inputfile.find_by(id: params[:inputfile_id])
    menu = parse_file
    @item_array = menu.find_combination
    @number_of_items = @item_array.length
    @target_price = menu.target_price
  end

  private
  def parse_file
    directory = "public"
    f = File.open(File.join(directory, @inputfile.attachment_url), 'r')
    item_array = []
    target_price = f.readline.tr("$","").to_f

    # Read in remaining items
    f.each_line do |line|
      item_name = line.split(",")[0]
      item_price = line.split(",")[1].tr("$","").to_f
      item = Item.new(item_name, item_price)
      item_array.push(item)
    end

    f.close

    return Menu.new(target_price, item_array)
  end
end