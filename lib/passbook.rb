require 'digest/sha1'
require 'openssl'
require 'zip/zip'
require 'base64'

module Passbook
  
  def self.createPass pass    
    @json = self.createJson(pass)
    
    AWS::S3::DEFAULT_HOST.replace "s3-us-west-1.amazonaws.com"
    AWS::S3::Base.establish_connection!(
        :access_key_id     => 'AKIAJZORP2CG2ZKHVMJQ',
        :secret_access_key => 'sK+LaL59L8BWY1beskIGBAaLSrjglJB3fw7Oyc2T')
        
    vendor = Vendor.find(pass.vendor_id)
        
    icon = AWS::S3::S3Object.find "gifty_assets/icon.png", "gifty"
    icon_2x = AWS::S3::S3Object.find "gifty_assets/icon@2x.png", "gifty"
    logo = AWS::S3::S3Object.find "gifty_assets/logo.png", "gifty"
    logo_2x = AWS::S3::S3Object.find "gifty_assets/logo@2x.png", "gifty"
    strip = AWS::S3::S3Object.find "vendor_assets/#{vendor.biz_id}/strip.png", "gifty"
    strip_2x = AWS::S3::S3Object.find "vendor_assets/#{vendor.biz_id}/strip@2x.png", "gifty"
    
    @wwdr_cert = AWS::S3::S3Object.find "secure/wwdr_cert.pem", "gifty"
    @signing_cert = AWS::S3::S3Object.find "secure/storecard_cert.p12", "gifty"
    @signing_cert_password = AWS::S3::S3Object.find "secure/cle.txt", "gifty"
    
    @files = Array.new
    @files << { :name => "icon.png", :content => icon.value}
    @files << { :name => "icon@2x.png", :content => icon_2x.value }
    @files << { :name => "logo.png", :content => logo.value}
    @files << { :name => "logo@2x.png", :content => logo_2x.value }
    @files << { :name => "strip.png", :content => strip.value}
    @files << { :name => "strip@2x.png", :content => strip_2x.value }
    
    manifest = self.createManifest
    signature = self.createSignature manifest
    
    zipPath = self.createZip pass, manifest, signature
    
    AWS::S3::S3Object.store("passes/#{vendor.biz_id}/#{pass.serial_number}.pkpass", open(zipPath), 'gifty')
    
    return zipPath
  end
  
  def self.createManifest    
    sha1s = {}
    sha1s['pass.json'] = Digest::SHA1.hexdigest @json

    @files.each do |file|
      if file.class == Hash
        sha1s[file[:name]] = Digest::SHA1.hexdigest file[:content]
      else
        sha1s[File.basename(file)] = Digest::SHA1.file(file).hexdigest
      end
    end

    return sha1s.to_json
  end

  def self.createSignature manifest
    p12   = OpenSSL::PKCS12.new @signing_cert.value, @signing_cert_password.value
    wwdc  = OpenSSL::X509::Certificate.new @wwdr_cert.value
    pk7   = OpenSSL::PKCS7.sign p12.certificate, p12.key, manifest.to_s, [wwdc], OpenSSL::PKCS7::BINARY | OpenSSL::PKCS7::DETACHED
    data  = OpenSSL::PKCS7.write_smime pk7

    str_debut = "filename=\"smime.p7s\"\n\n"
    data = data[data.index(str_debut)+str_debut.length..data.length-1]
    str_end = "\n\n------"
    data = data[0..data.index(str_end)-1]

    return Base64.decode64(data)
  end

  def self.createZip pass, manifest, signature
    t = Tempfile.new("#{pass.serial_number}.pkpass")

    zip_out = outputZip(manifest, signature)
    t.write zip_out.string
    path = t.path

    t.close
    return path
  end

  def self.outputZip manifest, signature

    Zip::ZipOutputStream.write_buffer do |zip|
      zip.put_next_entry 'pass.json'
      zip.write @json
      zip.put_next_entry 'manifest.json'
      zip.write manifest
      zip.put_next_entry 'signature'
      zip.write signature

      @files.each do |file|
        if file.class == Hash
          zip.put_next_entry file[:name]
          zip.print file[:content]
        else
          zip.put_next_entry File.basename(file)
          zip.print IO.read(file)
        end
      end
    end
  end
  
  def self.createJson pass
    vendor = Vendor.find(pass.vendor_id)
    
    jsonData = '{
      "formatVersion" : 1,
      "passTypeIdentifier" : "pass.com.gifty.storecard",
      "serialNumber" : "' + pass.serial_number.to_s + '",
      "teamIdentifier" : "PM4FU5U68E",
      "webServiceURL" : "https://gifty-test.herokuapp.com/service/",
      "authenticationToken" : "' + pass.authentication_token + '",
      "locations" : [
        {
          "longitude" : ' + vendor.longitude.to_s + ',
          "latitude" : ' + vendor.latitude.to_s + '
        }
      ],
      "organizationName" : "' + vendor.name + '",
      "description" : "Gift Card at ' + vendor.name + '",
      "logoText" : "' + vendor.name + '",
      "foregroundColor" : "' + vendor.foreground_color + '",
      "backgroundColor" : "' + vendor.background_color + '",
      "storeCard" : {
        "primaryFields" : [
          {
            "key" : "balance",
            "label" : "remaining balance",
            "value" : ' + pass.amount.to_s + ',
            "currencyCode" : "USD"
          }
        ],
        "secondaryFields" : [
          {
            "key" : "issued",
            "label" : "Issued By",
            "value" : "Gifty"
          },
          {
            "key" : "cardNumber",
            "label" : "Card Number",
            "value" : "' + pass.serial_number + '"
          }
        ],
        "backFields" : [
          {
    	      "key" : "redeem_url",
            "label" : "Press to Redeem Card",
    	      "value" : "http://trygifty.com/redeem/' + pass.serial_number + '"
          },
          {
            "key" : "terms",
            "label" : "TERMS AND CONDITIONS",
            "value" : "Gifty offers this pass, including all information, software, products and services available from this pass or offered as part of or in conjunction with this pass (the \"pass\"), to you, the user, conditioned upon your acceptance of all of the terms, conditions, policies and notices stated here. Gifty reserves the right to make changes to these Terms and Conditions immediately by posting the changed Terms and Conditions in this location.\n\nUse the pass at your own risk. This pass is provided to you \"as is,\" without warranty of any kind either express or implied. Neither Gifty nor its employees, agents, third-party information providers, merchants, licensors or the like warrant that the pass or its operation will be accurate, reliable, uninterrupted or error-free. No agent or representative has the authority to create any warranty regarding the pass on behalf of Gifty. Gifty reserves the right to change or discontinue at any time any aspect or feature of the pass."
          }
        ]
      }
    }'

    return jsonData
  end
  
end