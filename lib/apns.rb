require 'singleton'
require 'socket'
require 'openssl'

class APNS
  include Singleton
  attr_accessor :config, :certificate, :socket, :ssl_socket
  
  def initialize
    self.certificate = load_certificate
  end
  
  def load_certificate
    context = OpenSSL::SSL::SSLContext.new
    context.verify_mode = OpenSSL::SSL::VERIFY_NONE
    
    AWS::S3::DEFAULT_HOST.replace "s3-us-west-1.amazonaws.com"
    AWS::S3::Base.establish_connection!(
        :access_key_id     => 'AKIAJZORP2CG2ZKHVMJQ',
        :secret_access_key => 'sK+LaL59L8BWY1beskIGBAaLSrjglJB3fw7Oyc2T')
        
    @signing_cert = AWS::S3::S3Object.find "secure/storecard_cert.p12", "gifty"
    @signing_cert_password = AWS::S3::S3Object.find "secure/cle.txt", "gifty"
    
    # Import the certificate
    p12_certificate = OpenSSL::PKCS12::new(@signing_cert.value, @signing_cert_password.value)
    
    context.cert = p12_certificate.certificate
    context.key = p12_certificate.key
    
    # Return ssl certificate context
    return context
  end
  
  def open_connection(environment='sandbox')
    if self.certificate.class != OpenSSL::SSL::SSLContext
      load_certificate
    end
    
    if environment == "production"
      self.socket = TCPSocket.new("gateway.push.apple.com", 2195)
    else
      self.socket = TCPSocket.new("gateway.sandbox.push.apple.com", 2195)
    end
    self.ssl_socket = OpenSSL::SSL::SSLSocket.new(APNS.instance.socket, APNS.instance.certificate)

    # Open the SSL connection
    self.ssl_socket.connect
  end
  
  def close_connection
    APNS.instance.ssl_socket.close
    APNS.instance.socket.close
  end
  
  def deliver(token, payload)
    notification_packet = self.generate_notification_packet(token, payload)
    APNS.instance.ssl_socket.write(notification_packet)
  end
  
  def generate_notification_packet(token, payload)
    device_token_binary = [token.delete(' ')].pack('H*')
    
    packet =  [
                0,
                device_token_binary.size / 256,
                device_token_binary.size % 256,
                device_token_binary,
                payload.size / 256,
                payload.size % 256,
                payload
              ]
    packet.pack("ccca*cca*")
  end
end


