class Inputfile < ActiveRecord::Base
  mount_uploader :attachment, AttachmentUploader
  validates :name, presence: true
  # custom validations on attachment
  validate :target_price_must_be_valid

  def target_price_must_be_valid
    directory = "public"
    f = File.open(File.join(directory, self.attachment_url), 'r')
    line = f.readline
    if !valid_price?(line)
      errors.add(:line, "target price must be valid")
    end
    f.close
  end

  private
  def valid_price?(string_value)
    string_value = string_value.tr("$","")
    if string_value.to_f != 0.0 || string_value == "0.0"
      return true
    else
      return false
    end
  end

end
