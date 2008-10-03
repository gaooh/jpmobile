require File.dirname(__FILE__) + '/../spec_helper'

describe 'DoCoMoからのアクセス' do
  controller_name :mobile_spec
  it '1.0系の機種名称を取得できること' do
    request.env['HTTP_USER_AGENT'] = request.user_agent = "DoCoMo/1.0/SO506iC/c20/TB/W20H10"
    request.mobile.device_name.should == "SO506iC"
  end
  it '2.0系の機種名称を取得できること' do
    request.env['HTTP_USER_AGENT'] = request.user_agent = "DoCoMo/2.0 SH902i(c100;TB;W24H12)"
    request.mobile.device_name.should == "SH902i"
  end
end

describe 'Auからのアクセス' do
  controller_name :mobile_spec
  it '機種名称を取得できること' do
    request.env['HTTP_USER_AGENT'] = request.user_agent = "KDDI-CA33 UP.Browser/6.2.0.10.4 (GUI) MMP/2.0"
    request.mobile.device_name.should == "W41CA"
  end
end

describe 'Softbankからのアクセス' do
  controller_name :mobile_spec
  it '機種名称を取得できること' do
    request.env['HTTP_USER_AGENT'] = request.user_agent = "SoftBank/1.0/910T/TJ001/SN000000000000000 Browser/NetFront/3.3 Profile/MIDP-2.0 Configuration/CLDC-1.1"
    request.mobile.device_name.should == "910T"
  end
end

describe 'Vodafoneからのアクセス' do
  controller_name :mobile_spec
  it '機種名称を取得できること' do
    request.env['HTTP_USER_AGENT'] = request.user_agent = "Vodafone/1.0/V903SH/SHJ001/SN000000000000000 Browser/UP.Browser/7.0.2.1 Profile/MIDP-2.0 Configuration/CLDC-1.1 Ext-J-Profile/JSCL-1.2.2 Ext-V-Profile/VSCL-2.0.0"
    request.mobile.device_name.should == "V903SH"
  end
end

describe 'J-PHONEからのアクセス' do
  controller_name :mobile_spec
  it '機種名称を取得できること' do
    request.env['HTTP_USER_AGENT'] = request.user_agent = "J-PHONE/4.3/V603SH/SNXXXX0000000 SH/0007aa Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.3.2"
    request.mobile.device_name.should == "V603SH"
  end
end