require 'passbook'

class PassCreationJob < Struct.new(:pass)
  def perform
    Passbook.createPass(pass)
  end
end