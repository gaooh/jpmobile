require File.join(File.dirname(__FILE__), 'spec_helper')

describe 'JpmobileDevice' do
  
  before do
    database = YAML.load_file(File.expand_path('config/database.yml'))
    ActiveRecord::Base.establish_connection(database["test"]["jpmobile"])
    JpmobileDevice.delete_all
  end
  
  it 'gpsを利用しているかどうか判断する' do
    jpmobile_device = JpmobileDevice.new({:device => "AI011ST", :gps => true})
    jpmobile_device.save!
    
    device = JpmobileDevice.find_by_device("AI011ST")
    device.should_not nil
    device.gps?.should be_true
  end

  it 'hash情報をテーブルに保存する' do
    device = 
    {"N600i"=>
      {:gps=>false,
       :gif=>true,
       :jpg=>true,
       :name=>"N600i SIMPURE N",
       :png=>false,
       :flash=>false,
       :flash_version=>nil,
       :ssl=>false},
    "P900iV"=>
       {:gps=>true,
        :gif=>true,
        :jpg=>true,
        :name=>"P900iV",
        :png=>false,
        :flash=>false,
        :flash_version=>"1.0",
        :ssl=>false}
    }
    
    jpmobile_device = JpmobileDevice.save_from_hash(1, device)
    
    device = JpmobileDevice.find_by_device("N600i")
    device.should_not nil
    device.gps?.should be_false
    device.gif?.should be_true
    device.jpg?.should be_true
    device.name.should == "N600i SIMPURE N"
    device.png?.should be_false
    device.flash?.should be_false
    
    device = JpmobileDevice.find_by_device("P900iV")
    device.should_not nil
    device.name.should == "P900iV"
  end
  
end