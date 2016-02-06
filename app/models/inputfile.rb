class Inputfile < ActiveRecord::Base
  mount_uploader :attachment, AttachmentUploader
  validates :name, presence: true, length: { maximum: 50 }
  validates :description, presence: true, length: { maximum: 255 }
  validate :all_validations

  def all_validations
    # Validations
    target_price_must_be_valid
    not_too_many_items
    validate_lines
  end

  def target_price_must_be_valid
    f = open_file
    line = f.readline
    if !valid_price?(line)
      errors.add(:line, "target price must be valid and less than 25,000")
    end
    f.close
  end

  def not_too_many_items
    f = open_file
    number_of_lines = f.read.count("\n")
    if number_of_lines > 1000
      errors.add(:number_of_items, "There are too many items in the file you are trying to input")
    end
    f.close
  end

  def validate_lines
    f = open_file
    line = f.readline
    # Read in remaining items
    f.each_line do |line|
      if !line.include?(",")
        errors.add(:file, "Does not include a comma delimited line")
        break
      end
      item_name = line.split(",")[0]
      item_price = line.split(",")[1].tr("$","").to_f
      item = Item.new(name: item_name, price: item_price)
      puts "PRICE: #{item_price}"
      if !item.valid?
        errors.add(:item, "One of the uploaded items is not valid")
      end
    end
    f.close
  end

  private
  def valid_price?(string_value)
    string_value = string_value.tr("$","")
    if string_value.to_f != 0.0 || string_value == "0.0" && string_value.to_f < 25000
      return true
    else
      return false
    end
  end
  def open_file
    directory = "public"
    file_handle = File.open(File.join(directory, self.attachment_url), 'r')
    return file_handle
  end
end
