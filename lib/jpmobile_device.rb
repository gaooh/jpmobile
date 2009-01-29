require 'active_record'

class JpmobileDevice < ActiveRecord::Base 
  
  def self.save_from_hash(carrier_id, device_info)
    
    device_info.each_pair do |key, value|
      jpmobile_device = find(:first, :conditions => ['device = ?', key])
      
      if jpmobile_device.nil?
        jpmobile_device = self.new
        jpmobile_device.jpmobile_carrier_id = carrier_id
        jpmobile_device.device = key
        jpmobile_device.attributes = value
        jpmobile_device.save
        
      elsif Time.parse(value[:updated_at]) > jpmobile_device.updated_at 
        jpmobile_device.attributes = value
        jpmobile_device.save
      end
    end
  end
  
  def gps?
    self.gps
  end
  
end