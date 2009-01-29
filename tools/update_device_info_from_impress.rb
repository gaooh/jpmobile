#!/usr/bin/ruby -Ku
# impress から機種名を取得するスクリプト。

require 'rubygems'
require 'kconv'
require 'open-uri'
require 'fastercsv'
require 'pp'

USE_DB = false
OUTPUT_DIR = "/tmp/"

ARGV.each do |arg| 
 case
 when arg =~ /--url=/
   URL = arg.sub("--url=", "")
 when arg =~ /--username=/
   USERNAME = arg.sub("--username=", "")
 when arg =~ /--password=/
   PASSWORD = arg.sub("--password=", "")
 when arg =~ /--output-dir=/
   OUTPUT_DIR = arg.sub("--output-dir=", "")
 when arg =~ /--with-db/
   USE_DB = true
 end
end

file_name = URL.split("/").last
file_full_path = OUTPUT_DIR + file_name
unzip_output = OUTPUT_DIR + "profile/"

system("wget #{URL} --user=#{USERNAME} --password=#{PASSWORD} --directory-prefix=#{OUTPUT_DIR} --no-check-certificate")
system("unzip -o #{file_full_path} -d #{unzip_output} ")

user_agent = Dir::glob(unzip_output + "UserAgent*").first
user_agent_src = open(user_agent).read.toutf8

UA_INDEX_CARRIER          = 0  # キャリア名
UA_INDEX_DEVICE_NAME      = 1  # 機種名
UA_INDEX_KDDI_DEVICE_NAME = 2  # KDDIデバイスID

au_device = {}
au_kddi_device = {}
arryas = FasterCSV.parse(user_agent_src)
arryas.each_with_index do |array, index|
  next if index < 2
  
  case array[UA_INDEX_CARRIER]
  when "au", "Tu-Ka"
    devices = au_device[array[UA_INDEX_KDDI_DEVICE_NAME]]
    if devices.nil?
      au_device[array[UA_INDEX_KDDI_DEVICE_NAME]] = [ array[UA_INDEX_DEVICE_NAME] ]
    else
      devices << array[UA_INDEX_DEVICE_NAME]
      au_device[array[UA_INDEX_KDDI_DEVICE_NAME]] = devices
    end
  end
  
end
au_device.each_value do |value|
  value.uniq!
end

profile_data = Dir::glob(unzip_output + "ProfileData*").first
profile_data_src = open(profile_data).read.toutf8

class Module
  def enum args, b = nil
    val = -1
    args.split(/,/).each{|c|
      c = c.strip
      break if c.size == 0
      if /(\S+)\s*=\s*(.+)/ =~ c
        const_set($1, val = eval($2, b))
      else
        const_set(c.strip, val+=1)
      end
    }
  end
end

class ProfileData
  attr_accessor :filename
  attr_accessor :docomo, :au, :softbank, :willcom, :au_device
  
  enum %q{ 
      CARRIER, DEVICE_NAME, MFR, NICKNAME, RELEASE_DATE, SERIES, MARKUP_LANGUAGE, BROWSING_VERSION, BAUD,
      COLORS, GIF, JPEG, PNG, BMP2, BMP4, MNG, TRANSMISSION, SSL, CAMERA_PIXEL, CAMERA_PIXEL_2, 
      APP, APP_KIND, APP_VERSION, APP_MAX_CONTENT, MEMORY_SLOT, CHORD, 
      RINGER_MELODY_SONG, RINGER_MELODY_FULL, RINGER_MELODY_MOVIE, QR, FELICA, BLUETOOTH, FLASH, 
      CA_VERISIGN, CA_ENTRUST, CA_CYBER_TRUST, CA_GEOTRUST, CA_RSA_SECURITY, QVGA, FULL_BROWSER, INFRARED,
      ATTACHED_FILE_VIEWER, GPS, MOVIE, FULL_BROWSER_VERSION, FULL_BROWSER_USER_AGENT, ATTACHED_SIZE,
      FLASH_VERSION, CACHE_MAX, ONE_SEGMENT, TV_PHONE, OFFICE_WEBDL, OFFICE_FILE_SIZE, COOKIE, UID,
      SUICA, MAIL_URL_MAX, BOOKMARKURL_MAX, BROWSER_URL_MAX, PUSH_TALK, MAIL_SUBJECT_MAX, 
      ANIMATION_GIF, TRANSMISSION_GIF, MAIL_ATTACHED_FILE_SIZE, HTML_MAIL, KISEKAE, UPDATED_AT
    }, binding
  
  def initialize(filename, au_device)
    self.filename = filename
    self.au_device = au_device
    self.docomo = {}
    self.au = {}
    self.softbank = {}
    self.willcom = {}
  end
  
  def boolean_convert(value)
    value == "Y" ? true : false
  end
  
  def parse
    arryas = FasterCSV.parse(filename)
    
    arryas.each_with_index do |array, index|
      next if index < 2

      device_id = array[DEVICE_NAME]
      flash_version = array[FLASH_VERSION] == "0" ? nil : array[FLASH_VERSION].delete("Flash Lite ")

      name = array[DEVICE_NAME]
      name = name + " #{array[NICKNAME]}" unless array[NICKNAME].nil?
      
      info = { :name => name, 
               :gps => boolean_convert(array[GPS]),
               :jpg => boolean_convert(array[JPEG]),
               :gif => boolean_convert(array[GIF]), 
               :png => boolean_convert(array[PNG]), 
               :flash => boolean_convert(array[FLASH]), 
               :flash_version => flash_version,
               :ssl => boolean_convert(array[SSL]),
               :colors => array[COLORS],
               :chord => array[CHORD],
               :ringer_melody_song => boolean_convert(array[RINGER_MELODY_SONG]),
               :ringer_melody_song_full => boolean_convert(array[RINGER_MELODY_FULL]),
               :ringer_melody_movie => boolean_convert(array[RINGER_MELODY_MOVIE]),
               :qr => boolean_convert(array[QR]),
               :bluetooth => boolean_convert(array[BLUETOOTH]),
               :updated_at => array[UPDATED_AT]
      }

      case array[CARRIER]
        when "DoCoMo"       ; self.docomo[device_id] = info 
        when "au", "Tu-Ka"  
          self.au_device.each do |key, values|
            if values.index(device_id) 
              if values.size > 1
                name = ""
                values.each_with_index do |value, index|
                  if index == 0
                    name = value 
                  else 
                    name = name + "/" + value
                  end
                end
                info[:name] = name
              end
              self.au[key] = info
            end
          end
        when "SoftBank" ; self.softbank[device_id] = info 
        when "WILLCOM"  ; self.willcom[device_id] = info
      end

    end
  end
end

profile_data = ProfileData.new(profile_data_src, au_device)
profile_data.parse

if USE_DB
  require 'active_record'
  require File.join(File.dirname(__FILE__), '../lib/jpmobile_device')
  
  ENV['RAILS_ENV'] ||= 'development'
  
  database = YAML.load_file(File.expand_path('../config/database.yml'))
  ActiveRecord::Base.establish_connection(database[ENV['RAILS_ENV']]["jpmobile"])
  
  jpmobile_device = JpmobileDevice.save_from_hash(1, profile_data.docomo)
  jpmobile_device = JpmobileDevice.save_from_hash(2, profile_data.au)
  jpmobile_device = JpmobileDevice.save_from_hash(3, profile_data.softbank)
  jpmobile_device = JpmobileDevice.save_from_hash(4, profile_data.willcom)
  
else
  # 書き出し
  open("lib/jpmobile/mobile/z_device_info_docomo.rb","w") do |f|
    f.puts "Jpmobile::Mobile::Docomo::DEVICE_INFO = "
    f.puts profile_data.docomo.pretty_inspect
  end

  open("lib/jpmobile/mobile/z_device_info_au.rb","w") do |f|
    f.puts "Jpmobile::Mobile::Au::DEVICE_INFO = "
    f.puts profile_data.au.pretty_inspect
  end

  open("lib/jpmobile/mobile/z_device_info_softbank.rb","w") do |f|
    f.puts "Jpmobile::Mobile::Softbank::DEVICE_INFO = "
    f.puts profile_data.softbank.pretty_inspect
  end

  open("lib/jpmobile/mobile/z_device_info_willcom.rb","w") do |f|
    f.puts "Jpmobile::Mobile::Willcom::DEVICE_INFO = "
    f.puts profile_data.willcom.pretty_inspect
  end
end

File.delete("#{file_full_path}")

