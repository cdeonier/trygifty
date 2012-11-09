class Pass < ActiveRecord::Base
  belongs_to :vendor
  belongs_to :item
  has_one :transaction
  attr_accessible :amount, :serial_number
  
  before_create :generate_serial_number
  
  def generate_serial_number
    begin
      serial_number = SecureRandom.uuid
      serial_number = serial_number.split(/-/)[0]
      serial_number = serial_number.upcase
    end while Pass.where(:serial_number => serial_number).exists?
    self.serial_number = serial_number
  end
end
