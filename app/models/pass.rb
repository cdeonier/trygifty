class Pass < ActiveRecord::Base
  attr_accessible :amount, :serial_number, :authentication_token
  before_create :generate_token_and_serial
  
  belongs_to :vendor
  belongs_to :item
  has_one :transaction
  has_many :charges, :dependent => :destroy
  has_many :registrations
  has_many :devices, :through => :registrations
  
  def generate_token_and_serial
    begin
      serial_number = SecureRandom.uuid
      serial_number = serial_number.split(/-/)[0]
      serial_number = serial_number.upcase
    end while Pass.where(:serial_number => serial_number).exists?
    self.serial_number = serial_number
    
    begin
      token = SecureRandom.urlsafe_base64
    end while Pass.where(:authentication_token => token).exists?
    self.authentication_token = token
  end
end
