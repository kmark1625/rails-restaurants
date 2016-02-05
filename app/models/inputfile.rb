class Inputfile < ActiveRecord::Base
  mount_uploader :attachment, AttachmentUploader
  validates :name, presence: true, length: { maximum: 50 }
  validates :description, presence: true, length: { maximum: 255 }
  validate :target_price_must_be_valid, :not_too_many_items

  def target_price_must_be_valid
    directory = "public"
    f = File.open(File.join(directory, self.attachment_url), 'r')
    line = f.readline
    if !valid_price?(line)
      errors.add(:line, "target price must be valid and less than 25,000")
    end
    f.close
  end

  def not_too_many_items
    directory = "public"
    f = File.open(File.join(directory, self.attachment_url), 'r')
    number_of_lines = f.read.count("\n")
    f.close
    if number_of_lines > 1000
      errors.add(:number_of_items, "There are too many items in the file you are trying to input")
    end
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
end
