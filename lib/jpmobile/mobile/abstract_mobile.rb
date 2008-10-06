require 'ipaddr'

module Jpmobile::Mobile
  # 携帯電話の抽象クラス。
  class AbstractMobile
    def initialize(request)
      @request = request
    end

    # 対応するuser-agentの正規表現
    USER_AGENT_REGEXP = nil
    # 対応するメールアドレスの正規表現
    MAIL_ADDRESS_REGEXP = nil
    
    # 緯度経度があれば Position のインスタンスを返す。
    def position; return nil; end

    # 契約者又は端末を識別する文字列があれば返す。
    def ident; ident_subscriber || ident_device; end
    # 契約者を識別する文字列があれば返す。
    def ident_subscriber; nil; end
    # 端末を識別する文字列があれば返す。
    def ident_device; nil; end
    
    def self.device_info device, key
      device_info = self::DEVICE_INFO[device] 
      device_info.nil? ? nil : device_info[key]
    end
    
    # デバイスIDがあれば返す。
    def device_id; nil; end
    
    # 機種名称があれば返す。
    def device_name
      self.class.device_info(device_id, :name)
    end
    
    # cssに対応しているか。
    def css?
      self.class.device_info(device_id, :css)
    end
    
    # gif画像に対応しているか。
    def gif?
      self.class.device_info(device_id, :gif)
    end
    
    # jpg画像に対応しているか。
    def jpg?
      self.class.device_info(device_id, :jpg)
    end
    
    # png画像に対応しているか。
    def png?
      self.class.device_info(device_id, :png)
    end
    
    # flashに対応しているか。
    def flash?
      self.class.device_info(device_id, :flash)
    end
    
    # flash_versionを取得。flashに対応していない場合nilが返る。
    def flash_version
      self.class.device_info(device_id, :flash_version)
    end
    
    # sslに対応しているか。
    def ssl?
      self.class.device_info(device_id, :ssl)
    end
    
    # 当該キャリアのIPアドレス帯域からのアクセスであれば +true+ を返す。
    # そうでなければ +false+ を返す。
    # IP空間が定義されていない場合は +nil+ を返す。
    def self.valid_ip? remote_addr
      addrs = nil
      begin
        addrs = self::IP_ADDRESSES
      rescue NameError => e
        return nil
      end
      remote = IPAddr.new(remote_addr)
      addrs.any? {|ip| ip.include? remote }
    end

    def valid_ip?
      @__valid_ip ||= self.class.valid_ip? @request.remote_addr
    end

    # 画面情報を +Display+ クラスのインスタンスで返す。
    def display
      @__displlay ||= Jpmobile::Display.new
    end

    # クッキーをサポートしているか。
    def supports_cookie?
      return false
    end

    #XXX: lib/jpmobile.rbのautoloadで先に各キャリアの定数を定義しているから動くのです
    Jpmobile::Mobile.carriers.each do |carrier|
      carrier_class = Jpmobile::Mobile.const_get(carrier)
      next if carrier_class == self

      define_method "#{carrier.downcase}?" do
        self.is_a?(carrier_class)
      end
    end

    private
    # リクエストのパラメータ。
    def params
      if @request.respond_to? :parameters
        @request.parameters
      else
        @request.params
      end
    end
  end
end
